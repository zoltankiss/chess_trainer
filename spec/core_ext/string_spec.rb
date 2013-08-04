require File.expand_path('../../../config/initializers/core_ext/string', __FILE__)

describe String do
  describe '#remove_newlines' do
    it do
      '''
foo
bar
'''.remove_newlines.should == 'foobar'
    end

    it do
      "foo\nbar".remove_newlines.should == 'foobar'
    end
  end
end