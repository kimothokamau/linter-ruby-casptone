class TrailingSpaceClass
  attr_reader :regxp, :error_message

  def initialize
    @regxp = /\. [a-zA-Z0-9-]/
    @error_message = 'There should be no empty space after calling a class selector'
  end
end

class TrailingSpaceID
  attr_reader :regxp, :error_message

  def initialize
    @regxp = /\# [a-zA-Z0-9-]/
    @error_message = 'There should be no empty space after calling a ID selector'
  end
end

class SpaceBeforeCurlyClass
  attr_reader :regxp, :error_message

  def initialize
    @regxp = /\.[a-zA-Z0-9-]+\{/
    @error_message = 'There should be an empty space before the opening curly braces'
  end
end

class SpaceBeforeCurlyID
  attr_reader :regxp, :error_message

  def initialize
    @regxp = /\#[a-zA-Z0-9-]+\{/
    @error_message = 'There should be an empty space before the opening curly braces'
  end
end

class EmptyRule
  attr_reader :regxp, :error_message

  def initialize
    @regxp = /\.[a-zA-Z0-9-]+\s{\s*}/
    @error_message = 'There is no CSS rule inside the curly braces'
  end
end
