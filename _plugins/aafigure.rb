# Modified from: https://gist.github.com/nikomatsakis/5760007

require './_plugins/raw'

module Jekyll

  class Aafigure < Liquid::Block
    include TemplateWrapper
    def initialize(tag_name, markup, tokens)
      super
      @opts = markup
    end

    def render(context)
      code = super

      full_output = ""
      IO.popen("aafigure #{@opts} --type svg", "w+") do |pipe|
        pipe.puts code
        pipe.close_write
        full_output = pipe.read
      end

      # aafigure emits something like
      #  <?xml ...?>
      #  <!DOCTYPE...>
      #
      #  <svg...>...</svg>
      # We just want to skip the first three lines.
      # full_output.split("\n")[3..-1].join("\n") + "\n"
      lines = full_output.split("\n")
      result = ""
      counter = 0
      lines.each do |line|
        if counter < 3
          counter += 1
        else
          result += line + "\n"
        end
      end
      "<div>#{result}</div>"

    end
  end
end

Liquid::Template.register_tag('aafigure', Jekyll::Aafigure)
