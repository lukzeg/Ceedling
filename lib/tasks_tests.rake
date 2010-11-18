
namespace TESTS_TASKS_ROOT_NAME.to_sym do
  
  desc "Run all unit tests."
  task :all => [:directories] do
    @ceedling[:test_invoker].setup_and_invoke(COLLECTION_ALL_TESTS)
  end

  COLLECTION_ALL_TESTS.each do |test|
    # by test file name
    name = File.basename(test)
    task name.to_sym => [:directories] do
      @ceedling[:test_invoker].setup_and_invoke(test)
    end

    # by source file name
    name = File.basename(test).sub(/#{PROJECT_TEST_FILE_PREFIX}/, '')
    task name.to_sym => [:directories] do
      @ceedling[:test_invoker].setup_and_invoke(test)
    end
    
    # by header file name
    name = File.basename(test).ext(EXTENSION_HEADER).sub(/#{PROJECT_TEST_FILE_PREFIX}/, '')
    task name.to_sym => [:directories] do
      @ceedling[:test_invoker].setup_and_invoke(test)
    end
  end

  desc "Run tests for changed files."
  task :delta => [:directories] do
    @ceedling[:test_invoker].setup_and_invoke(COLLECTION_ALL_TESTS, {:force_run => false})
  end
  
  desc "Run tests by matching regular expression pattern."
  task :pattern, [:regex] => [:directories] do |t, args|
    matches = []
    
    COLLECTION_ALL_TESTS.each { |test| matches << test if (test =~ /#{args.regex}/) }
  
    if (matches.size > 0)
      @ceedling[:test_invoker].setup_and_invoke(matches, {:force_run => false})
    else
      @ceedling[:streaminator].stdout_puts("\nFound no tests matching pattern /#{args.regex}/.")
    end
  end

  desc "Run tests whose path contains [dir] or [dir] string."
  task :path, [:dir] => [:directories] do |t, args|
    matches = []
    
    COLLECTION_ALL_TESTS.each { |test| matches << test if File.dirname(test).include?(args.dir.gsub(/\\/, '/')) }
  
    if (matches.size > 0)
      @ceedling[:test_invoker].setup_and_invoke(matches, {:force_run => false})
    else
      @ceedling[:streaminator].stdout_puts("\nFound no tests including the given path or path component.")
    end
  end
  
end