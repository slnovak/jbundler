#
# Copyright (C) 2013 Kristian Meier
#
# Permission is hereby granted, free of charge, to any person obtaining a copy of
# this software and associated documentation files (the "Software"), to deal in
# the Software without restriction, including without limitation the rights to
# use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
# the Software, and to permit persons to whom the Software is furnished to do so,
# subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
# FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
# COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
# IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
# CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#
require 'thor'
module JBundler
  class Cli < Thor
    no_tasks do
      def mvn
        @mvn ||= Maven::Ruby::Maven.new
      end

      def do_show
        require 'java' 
        require 'jbundler/config'
        require 'jbundler/classpath_file'
        config = JBundler::Config.new
        classpath_file = JBundler::ClasspathFile.new(config.classpath_file)
        if classpath_file.exists?
          classpath_file.require_classpath unless defined? JBUNDLER_CLASSPATH
          puts "JBundler classpath:"
          JBUNDLER_CLASSPATH.each do |path|
            puts "  * #{path}"
          end
        else
          puts "JBundler classpath is not installed."
        end
      end
    end
    
    desc 'console', 'irb session with gems and/or jars and with lazy jar loading.'
    def console
      # dummy - never executed !!!
    end
    
    desc 'install', "first `bundle install` is called and then the jar dependencies will be installed. for more details see `bundle help install`, jbundler will ignore all options. the install command is also the default when no command is given."
    def install
      require 'jbundler'
      do_show
      puts 'Your jbundle is complete! Use `jbundle show` to see where the bundled jars are installed.'
    end

    desc 'update', "first `bundle update` is called and if there are no options then the jar dependencies will be updated. for more details see `bundle help update`."
    def update
      if ARGV.size == 1
        require 'java'
        require 'jbundler/config'
        config = JBundler::Config.new
        FileUtils.rm_f(config.jarfile_lock)
        
        require 'jbundler'
        do_show
        puts ''
        puts 'Your jbundle is updated! Use `jbundle show` to see where the bundled jars are installed.'
      end
    end

    desc 'show', "first `bundle show` is called and if there are no options then the jar dependencies will be displayed. for more details see `bundle help show`."
    def show
      if ARGV.size == 1
        do_show
     end
    end
  end
end