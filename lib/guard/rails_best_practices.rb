require 'guard'
require 'guard/guard'
require File.join(File.dirname(__FILE__), "rails_best_practices/version")

module Guard
  class Rails_best_practices < Guard
    autoload :Notifier, 'guard/annotate/notifier'

    def initialize(watchers = [], options = {})
      super
      options[:vendor]   = true   if options[:vendor].nil?
      options[:spec]     = true   if options[:spec].nil?
      options[:test]     = true   if options[:test].nil?
      options[:features] = true   if options[:features].nil?
      options[:exclude]  = ''     if options[:exclude].nil?

      options[:run_at_start] = true if options[:run_at_start].nil?
    end

    def start
      run_bestpractices if options[:run_at_start]
    end

    def stop
      true
    end

    def reload
      run_bestpractices
    end

    def run_all
      run_bestpractices
    end

    def run_on_change(paths)
      run_bestpractices
    end

    def run_on_deletion(paths)
    end

    def notify?
      !!options[:notify]
    end

  private
    def run_bestpractices
      UI.info 'Running Rails Best Practices checklist', :reset => true
      started_at = Time.now

      cmd = 'rails_best_practices'
      cmd += ' --vendor'   if options[:vendor]
      cmd += ' --spec'     if options[:spec]
      cmd += ' --test'     if options[:test]
      cmd += ' --features' if options[:features]
      cmd += ' --output-file ' + options[:output_file] if options[:output_file]
      cmd += ' --format ' + options[:format]           if options[:format]
      cmd += " --exclude #{options[:exclude]}" unless options[:exclude].blank?
      @result = system(cmd)

      Notifier::notify( @result, Time.now - started_at ) if notify?
      @result
    end

  end
end
