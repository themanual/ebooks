require 'nokogiri'

task default: 'build-all'

##### INDIVIDUAL STEPS

namespace :steps do
  desc 'Parse markup'
  task :parse, :issue do |task, args|
    print " - Parsing issue-#{args[:issue]}\n"
    wd = Dir.getwd
    Dir.chdir "#{wd}/issue-#{args[:issue]}"
    `bundle exec jekyll build`
    Dir.chdir wd
  end

  desc 'Fixup markup'
  task :fixup, :issue do |task, args|
    print " - Fixing up issue-#{args[:issue]}\n"

    wd = Dir.getwd
    Dir.chdir "#{wd}/issue-#{args[:issue]}/_site"
    Dir.glob('**/*.xhtml') do |xhtml|

      doc = Nokogiri::XML(open(xhtml))

      #  <sup id="fnref:lanier"><a href="#fn:lanier" class="footnote">1</a></sup>
      #TO
      #  <sup id="fnref-lanier"><a href="#fn-lanier" epub:type="noteref" class="footnote">1</a></sup>
      doc.css('sup[id^="fnref:"]').each do |sup|
        sup.css('a[href^="#fn:"]').each do |a|
          a['href'] = a['href'].gsub(':','-')
          a['epub:type'] = 'noteref'
        end
        sup['id'] = sup['id'].gsub(':','-')
      end

      #  <li id="fn:lanier">
      #    <p>Jaron Lanier, <em><a href="http://www.jaronlanier.com/gadgetwebresources.html">You Are Not a Gadget: A Manifesto</a></em>, (Vintage Books, 2011). <a href="#fnref:lanier" class="reversefootnote">&#8617;</a></p>
      #  </li>
      #TO
      #  <li id="fn-lanier" epub:type="footnote">
      #    <p>Jaron Lanier, <em><a href="http://www.jaronlanier.com/gadgetwebresources.html">You Are Not a Gadget: A Manifesto</a></em>, (Vintage Books, 2011). <a href="#fnref-lanier" class="reversefootnote">&#8617;</a></p>
      #  </li>
      # `sed -i '' -E 's/li id=\\"fn:([a-z-]*)\\"/li id=\\"fn-\\1\\" epub:type=\\"footnote\\"/g' #{xhtml}`
      # `sed -i '' -e 's/href=\\"#fnref:/href=\\"#fnref-/g' #{xhtml}`
      doc.css('li[id^="fn:"]').each do |li|
        li.css('a[href^="#fnref"]').each do |a|
          a['href'] = a['href'].gsub(':','-')
        end
        li['id'] = li['id'].gsub(':','-')
        li['epub:type'] = 'footnote'
      end

      File.open(xhtml, 'w') do |f|
          f.write doc.to_xml
      end

    end
    Dir.chdir wd
  end

  desc 'Package epub'
  task :package, :issue do |task, args|
    print " - Packaging issue-#{args[:issue]}\n"
    wd = Dir.getwd
    Dir.chdir "#{wd}/issue-#{args[:issue]}/_site"
    File.unlink "../issue-#{args[:issue]}.epub" rescue nil
    `zip -0Xq ../issue-#{args[:issue]}.epub mimetype`
    `zip -Xr9Dq ../issue-#{args[:issue]}.epub * -x mimetype -x issue-`
    Dir.chdir wd
  end

  desc 'Validate epub'
  task :validate, :issue do |task, args|
    print " - Validating issue-#{args[:issue]}\n"

    wd = Dir.getwd
    Dir.chdir "#{wd}/generator/bin/epubcheck-3.0.1"
    `java -jar epubcheck-3.0.1.jar ../../../issue-#{args[:issue]}/issue-#{args[:issue]}.epub`
    if $? != 0
      print "\n\n **** ERROR VALIDATING EPUB ****\n\n"
      exit
    end
    Dir.chdir wd

  end

  desc 'Generate kindle version'
  task :kindlegen, :issue do |task, args|
    print " - Kindlegen'ing issue-#{args[:issue]}\n"

    wd = Dir.getwd
    kgdir = "#{wd}/generator/bin/kindlegen-2.9"
    Dir.chdir kgdir
    cmd = "./kindlegen ../../../issue-#{args[:issue]}/issue-#{args[:issue]}.epub -c2 -o issue-#{args[:issue]}.mobi"
    `#{cmd}`
    if $?.exitstatus > 1
      print "\n\n **** ERROR CONVERTING EPUB ****\n\n"
      exit
    end

    if $?.exitstatus == 1
      print "   ** warnings raised, run 'cd #{kgdir} && #{cmd}' to view them\n"
    end

    Dir.chdir wd

  end

end

desc 'Build a single Issue'
task :build, :issue do |task, args|
  print "* Building issue-#{args[:issue]}\n"
  Rake::Task["steps:parse"].execute :issue => args[:issue]
  Rake::Task["steps:fixup"].execute :issue => args[:issue]
  Rake::Task["steps:package"].execute :issue => args[:issue]
  Rake::Task["steps:validate"].execute :issue => args[:issue]
  Rake::Task["steps:kindlegen"].execute :issue => args[:issue]
  print "* Built issue-#{args[:issue]}\n\n\n"
end

desc 'Build all Issues'
task 'build-all' do
  issues = Dir.glob('issue-*').select{|issue| issue =~ /^issue-\d.*$/}

  issues.each do |issue|
    Rake::Task["build"].execute :issue => issue.sub('issue-','')
  end
end
