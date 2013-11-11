require "digest/md5"

module Spambust
  module FormHelpers
    def input(paths, options = {})
      type               = options.delete(:type) || "text"
      options_without_id = options.select { |key, value| key != :id }
      others             = hash_to_options(options)
      others_without_id  = hash_to_options(options_without_id)
      digested_paths     = paths.map { |path| Digest::MD5.hexdigest(path) }
      %Q(<input type="#{type}" name="#{namify digested_paths}"#{others} /><input type="hidden" name="#{namify paths}"#{others_without_id} />)
    end

    def submit(text, options = {})
      others = hash_to_options(options)
      %Q(<input type="submit" value="#{text}"#{others} />)
    end

    def namify(paths)
      first = paths[0]
      rest  = paths[1..-1].reduce("") { |acc, path| acc << "[#{path}]" }
      "#{first}#{rest}"
    end

    def decrypt(lookup, global)
      fake = global[lookup] || {}
      hashed_lookup = Digest::MD5.hexdigest(lookup)
      subset = global[hashed_lookup] || {}

      fake.reduce({}) do |real, (key, value)|
        real[key] = subset[Digest::MD5.hexdigest(key)]
        real
      end
    end

    def valid?(lookup, global)
      fake = global[lookup] || {}
      fake.none? { |key, value| value != "" }
    end

    def hash_to_options(hash)
      hash.reduce("") { |acc, (key, value)| acc << %Q( #{key}="#{value}") }
    end
    private :hash_to_options
  end
end
