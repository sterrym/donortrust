#
# test/spec -- a BDD interface for Test::Unit
#
# Copyright (C) 2006, 2007  Christian Neukirchen <mailto:chneukirchen@gmail.com>
#
# This work is licensed under the same terms as Ruby itself.
#

require 'test/unit'

class Test::Unit::AutoRunner    # :nodoc:
  RUNNERS[:specdox] = lambda {
    require 'test/spec/dox'
    Test::Unit::UI::SpecDox::TestRunner
  }

  RUNNERS[:rdox] = lambda {
    require 'test/spec/rdox'
    Test::Unit::UI::RDox::TestRunner
  }
end

module Test                     # :nodoc:
end

module Test::Spec
  VERSION = "0.3" if VERSION == nil
  
  CONTEXTS = {}                 # :nodoc:

  class DefinitionError < StandardError
  end

  class Should
    include Test::Unit::Assertions

    def self.deprecated_alias(to, from)    # :nodoc:
      define_method(to) { |*args|
        warn "Test::Spec::Should##{to} is deprecated and will be removed in future versions."
        __send__ from, *args
      }
    end

    def initialize(object, message=nil)
      @object = object
      @message = message
    end

    $TEST_SPEC_TESTCASE = nil
    def add_assertion
      $TEST_SPEC_TESTCASE && $TEST_SPEC_TESTCASE.__send__(:add_assertion)
    end


    def an
      self
    end

    def a
      self
    end

    def not(*args)
      case args.size
      when 0
        ShouldNot.new(@object, @message)
      when 1
        ShouldNot.new(@object, @message).pass(args.first)
      else
        raise ArgumentError, "#not takes zero or one argument(s)."
      end
    end

    def messaging(message)
      @message = message.to_s
      self
    end
    alias blaming messaging

    def satisfy(&block)
      assert_block(@message || "satisfy block failed.") {
        yield @object
      }
    end

    def equal(value)
      assert_equal value, @object, @message
    end
    alias == equal

    def close(value, delta)
      assert_in_delta value, @object, delta, @message
    end
    deprecated_alias :be_close, :close

    def be(*value)
      case value.size
      when 0
        self
      when 1
        if CustomShould === value.first 
          pass value.first
        else
          assert_same value.first, @object, @message
        end
      else
        raise ArgumentError, "should.be needs zero or one argument"
      end
    end

    def match(value)
      assert_match value, @object, @message
    end
    alias =~ match

    def instance_of(klass)
      assert_instance_of klass, @object, @message
    end
    deprecated_alias :be_an_instance_of, :instance_of

    def kind_of(klass)
      assert_kind_of klass, @object, @message
    end
    deprecated_alias :be_a_kind_of, :kind_of

    def respond_to(method)
      assert_respond_to @object, method, @message
    end

    def _raise(*args)
      args = [RuntimeError]  if args.empty?
      assert_raise(*(args + [@message]), &@object)
    end

    def throw(*args)
      assert_throws(*(args + [@message]), &@object)
    end

    def nil
      assert_nil @object, @message
    end
    deprecated_alias :be_nil, :nil


    def include(value)
      msg = build_message(@message, "<?> expected to include ?, but it didn't.",
                          @object, value)
      assert_block(msg) { @object.include?(value) }
    end

    def >(value)
      assert_operator @object, :>, value, @message
    end

    def >=(value)
      assert_operator @object, :>=, value, @message
    end

    def <(value)
      assert_operator @object, :<, value, @message
    end

    def <=(value)
      assert_operator @object, :<=, value, @message
    end

    def ===(value)
      assert_operator @object, :===, value, @message
    end

    def pass(custom)
      _wrap_assertion {
        assert_nothing_raised(Test::Unit::AssertionFailedError,
                              @message || custom.failure_message) {
          assert custom.matches?(@object), @message || custom.failure_message
        }
      }
    end

    def method_missing(name, *args)
      # This will make raise call Kernel.raise, and self.raise call _raise.
      return _raise(*args)  if name == :raise
      
      if @object.respond_to?("#{name}?")
        assert @object.__send__("#{name}?", *args),
          "#{name}? expected to be true. #{@message}"
      else
        super
      end
    end
  end

  class ShouldNot
    include Test::Unit::Assertions

    def initialize(object, message=nil)
      @object = object
      @message = message
    end

    def satisfy(&block)
      assert_block(@message || "not.satisfy block succeded.") {
        not yield @object
      }
    end
    
    def equal(value)
      assert_not_equal value, @object, @message
    end
    alias == equal

    def be(*value)
      case value.size
      when 0
        self
      when 1
        if CustomShould === value.first 
          pass value.first
        else
          assert_not_same value.first, @object, @message
        end
      else
        Kernel.raise ArgumentError, "should.be needs zero or one argument"
      end
    end

    def match(value)
      # Icky Regexp check
      assert_no_match value, @object, @message
    end
    alias =~ match

    def _raise(*args)
      assert_nothing_raised(*(args+[@message]), &@object)
    end

    def throw
      assert_nothing_thrown(@message, &@object)
    end

    def nil
      assert_not_nil @object, @message
    end

    def be_nil
      warn "Test::Spec::ShouldNot#be_nil is deprecated and will be removed in future versions."
      self.nil
    end

    def not(*args)
      case args.size
      when 0
        Should.new(@object, @message)
      when 1
        Should.new(@object, @message).pass(args.first)
      else
        raise ArgumentError, "#not takes zero or one argument(s)."
      end
    end

    def pass(custom)
      _wrap_assertion {
        begin
          assert !custom.matches?(@object), @message || custom.failure_message
        end
      }
    end

    def method_missing(name, *args)
      # This will make raise call Kernel.raise, and self.raise call _raise.
      return _raise(*args)  if name == :raise

      if @object.respond_to?("#{name}?")
        assert_block("#{name}? expected to be false. #{@message}") {
          not @object.__send__("#{name}?", *args)
        }
      else
        super
      end
    end
    
  end

  class CustomShould
    attr_accessor :object
    
    def initialize(obj)
      self.object = obj
    end

    def failure_message
      "#{self.class.name} failed"
    end

    def matches?(*args, &block)
      assumptions(*args, &block)
      true
    end

    def assumptions(*args, &block)
      raise NotImplementedError, "you need to supply a #{self.class}#matches? method"
    end
  end
end

class Test::Spec::TestCase
  attr_reader :testcase
  attr_reader :name
  attr_reader :position

  module InstanceMethods
    def setup                 # :nodoc:
      $TEST_SPEC_TESTCASE = self
      super
      self.class.setups.each { |s| instance_eval(&s) }
    end
    
    def teardown              # :nodoc:
      super
      self.class.teardowns.each { |t| instance_eval(&t) }
    end

    def initialize(name)
      super name

      # Don't let the default_test clutter up the results and don't
      # flunk if no tests given, either.
      throw :invalid_test  if name == :default_test
    end

    def position
      self.class.position
    end

    def context(*args)
      raise Test::Spec::DefinitionError,
        "context definition is not allowed inside a specify-block"
    end
  end

  module ClassMethods
    attr_accessor :count
    attr_accessor :name
    attr_accessor :position
    attr_accessor :parent

    attr_accessor :setups
    attr_accessor :teardowns

    def context(name, &block)
      (Test::Spec::CONTEXTS[self.name + "\t" + name] ||=
       Test::Spec::TestCase.new(name, self)).add(&block)
    end
    
    def specify(specname, &block)
      raise ArgumentError, "specify needs a block"  if block.nil?
      
      self.count += 1                 # Let them run in order of definition
      
      define_method("test_spec {%s} %03d [%s]" % [name, count, specname], &block)
    end

    def xspecify(specname, &block)
      raise ArgumentError, "xspecify needs a block"  if block.nil?

      specify specname do
        @_result.add_disabled(specname)
      end
    end
    
    def setup(&block)
      setups << block
    end
    
    def teardown(&block)
      teardowns << block
    end

    def init(name, position, parent)
      self.position = position
      self.parent = parent
      
      if parent
        self.name = parent.name + "\t" + name
      else
        self.name = name
      end

      self.count = 0
      self.setups = []
      self.teardowns = []
    end
  end

  @@POSITION = 0

  def initialize(name, parent=nil)
    @testcase = Class.new(Test::Unit::TestCase) {
      include InstanceMethods
      extend ClassMethods
    }

    @@POSITION = @@POSITION + 1
    @testcase.init(name, @@POSITION, parent)
  end

  def add(&block)
    raise ArgumentError, "context needs a block"  if block.nil?

    @testcase.class_eval(&block)
    self
  end
end

class Test::Spec::Disabled < Test::Unit::Failure    # :nodoc:
  def initialize(name)
    @name = name
  end

  def single_character_display
    "D"
  end

  def short_display
    @name
  end

  def long_display
    @name + " is disabled"
  end
end


# Monkey-patch test/unit to run tests in an optionally specified order.
module Test::Unit               # :nodoc:
  class TestSuite               # :nodoc:
    undef run
    def run(result, &progress_block)
      sort!
      yield(STARTED, name)
      @tests.each do |test|
        test.run(result, &progress_block)
      end
      yield(FINISHED, name)
    end
    
    def sort!
      @tests = @tests.sort_by { |test|
        test.respond_to?(:position) ? test.position : 0
      }
    end
    
    def position
      @tests.first.respond_to?(:position) ? @tests.first.position : 0
    end
  end

  class TestResult              # :nodoc:
    # Records a disabled test.
    def add_disabled(name)
      notify_listeners(FAULT, Test::Spec::Disabled.new(name))
      notify_listeners(CHANGED, self)
    end  
  end
end



#-- Global helpers

class Object
  def should(*args)
    case args.size
    when 0
      Test::Spec::Should.new(self)
    when 1
      Test::Spec::Should.new(self).pass(args.first)
    else
      raise ArgumentError, "Object#should takes zero or one argument(s)."
    end
  end
end

module Kernel
  def context(name, &block)     # :doc:
    (Test::Spec::CONTEXTS[name] ||= Test::Spec::TestCase.new(name)).add(&block)
  end

  private :context
end
