require "digest/md5"

module Spambust
  module FormHelpers
    def input(paths, options = {})
      type = options.delete(:type) || "text"
      digested_paths = paths.map { |path| Digest::MD5.hexdigest(path) }
      others = options.reduce("") { |acc, (k, v)| acc << %Q( #{k}="#{v}") }
      others_without_id = options.select { |k, v| k != :id }.reduce("") { |acc, (k, v)| acc << %Q( #{k}="#{v}") }
      %Q(<input type="#{type}" name="#{namify digested_paths}"#{others} /><input type="hidden" name="#{namify paths}"#{others_without_id} />)
    end

    def submit(text, options = {})
      others = options.reduce("") { |acc, (k, v)| acc << %Q( #{k}="#{v}") }
      %Q(<input type="submit" value="#{text}"#{others} />)
    end

    def namify(path)
      return path.first if path.size == 1
      "#{path[0]}[#{namify path[1..-1]}]"
    end
  end
end
