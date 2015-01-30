
require File.expand_path("../test_helper", __FILE__)

class EnumerizeTest < SearchCop::TestCase
  def test_mapping
    comment = create(:comment, :state => :new)

    assert_includes Comment.unsafe_search("state: new"), comment
    assert_includes Comment.unsafe_search("state: 1"), comment

    comment = create(:comment, :state => :rejected)

    assert_includes Comment.unsafe_search("state: rejected"), comment
    assert_includes Comment.unsafe_search("state: 3"), comment
    assert_includes Comment.unsafe_search("state> 2"), comment
  end

  def test_incompatible_datatype
    assert_raises SearchCop::IncompatibleDatatype do
      Comment.unsafe_search "state: Value"
    end
  end
end

