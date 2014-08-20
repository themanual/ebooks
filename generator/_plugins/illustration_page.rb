module Jekyll
  class IllustrationPage < Page
    def initialize(site, base, dir, author, order)
      @site = site
      @base = base
      @dir  = dir
      @name = "author-#{order}-article-illo.xhtml"
      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'article-illo.html')
      self.data['author'] = author
    end
  end

  class IllustrationPageGenerator < Generator
    def generate(site)
      site.data["issue"]["toc"].each_with_index do |(author, entry), index|
        site.pages << IllustrationPage.new(site, site.source, 'EPUB/html/content', author, index+1)
      end
    end
  end
end