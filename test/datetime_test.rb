
require File.expand_path("../test_helper", __FILE__)

class DatetimeTest < SearchCop::TestCase
  def test_mapping
    product = create(:product, :created_at => Time.zone.parse("2014-07-31 23:59:59"))

    assert_includes Product.search("created_at: 2014"), product
    assert_includes Product.search("created_at: 2014-07"), product
    assert_includes Product.search("created_at: 2014-07-31"), product
    assert_includes Product.search("created_at: '2014-07-31 23:59:59'"), product
    assert_includes Product.search("created_at>= '2014-07-31 23:59:59'"), product
    assert_includes Product.search("created_at<= '2014-07-31 23:59:59'"), product
    assert_includes Product.search("created_at: '31-07-2014 23:59:59'"), product
  end

  def test_anywhere
    product = create(:product, :created_at => Time.zone.parse("2014-05-01"))

    assert_includes Product.search("2014-05-01"), product
    refute_includes Product.search("2014-05-02"), product
  end

  def test_includes
    product = create(:product, :created_at => Time.zone.parse("2014-05-01"))

    assert_includes Product.search("created_at: 2014-05-01"), product
    refute_includes Product.search("created_at: 2014-05-02"), product
  end

  def test_equals
    product = create(:product, :created_at => Time.zone.parse("2014-05-01"))

    assert_includes Product.search("created_at = 2014-05-01"), product
    refute_includes Product.search("created_at = 2014-05-02"), product
  end

  def test_equals_not
    product = create(:product, :created_at => Time.zone.parse("2014-05-01"))

    assert_includes Product.search("created_at != 2014-05-02"), product
    refute_includes Product.search("created_at != 2014-05-01"), product
  end

  def test_greater
    product = create(:product, :created_at => Time.zone.parse("2014-05-01"))

    assert_includes Product.search("created_at > 2014-04-01"), product
    refute_includes Product.search("created_at > 2014-05-01"), product
  end

  def test_greater_equals
    product = create(:product, :created_at => Time.zone.parse("2014-05-01"))

    assert_includes Product.search("created_at >= 2014-05-01"), product
    refute_includes Product.search("created_at >= 2014-05-02"), product
  end

  def test_less
    product = create(:product, :created_at => Time.zone.parse("2014-05-01"))

    assert_includes Product.search("created_at < 2014-05-02"), product
    refute_includes Product.search("created_at < 2014-05-01"), product
  end

  def test_less_equals
    product = create(:product, :created_at => Time.zone.parse("2014-05-02"))

    assert_includes Product.search("created_at <= 2014-05-02"), product
    refute_includes Product.search("created_at <= 2014-05-01"), product
  end

  def test_no_overflow
    assert_nothing_raised do
      Product.search("created_at: 1000000").to_a
    end
  end

  def test_nil
    product = create(:product, :available_at => nil)

    assert_includes Product.search("available_at = null"), product
    refute_includes Product.search("available_at != null"), product
  end

  def test_not_nil
    product = create(:product, :available_at => Time.zone.parse("2014-05-02"))

    assert_includes Product.search("available_at != null"), product
    refute_includes Product.search("available_at = null"), product
  end

  def test_incompatible_datatype
    assert_raises SearchCop::IncompatibleDatatype do
      Product.unsafe_search "created_at: Value"
    end
  end
end

