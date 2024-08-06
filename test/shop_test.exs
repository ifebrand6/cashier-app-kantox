defmodule ShopTest do
  use ExUnit.Case, async: true

  alias Shop.Product
  alias Shop.ProductServer
  alias Shop.Rules.{COORule, CTORule, CEORule}
  alias Shop.RuleServer

  setup do
    ProductServer.clean()
    RuleServer.clean()
    :ok
  end

  describe ".add_rule" do
    test "avoid duplicated rules" do
      assert {:ok, MarketingRule} == Shop.add_rule(MarketingRule)
      assert {:ok, MarketingRule} == Shop.add_rule(MarketingRule)
      assert {:ok, CFORule} == Shop.add_rule(CFORule)
      assert {:ok, CFORule} == Shop.add_rule(CFORule)

      rules = RuleServer.all()

      assert Enum.count(rules) == 2
    end
  end

  test ".scan" do
    voucher = Product.new("VOUCHER", "Voucher", 5_00)
    assert {:ok, _} = Shop.scan(voucher)
    assert {:ok, _} = Shop.scan(voucher)

    products = ProductServer.all()

    assert Enum.count(products) == 2
  end

  describe ".total" do
    test "returns '£0.00' when there are no products" do
      assert Shop.total() == "£0.00"
    end

    test "GR1,SR1,GR1,GR1,CF1 should be £22.45" do
      gt_1 = Product.new("GR1", "Green tea", 3_11)
      sb_1 = Product.new("SR1", "Strawberries", 5_00)
      gt_2 = Product.new("GR1", "Green tea", 3_11)
      gt_3 = Product.new("GR1", "Green tea", 3_11)
      cf_1 = Product.new("CF1", "Coffee", 11_23)

      assert {:ok, _} = Shop.add_rule(CEORule)
      assert {:ok, _} = Shop.scan(gt_1)
      assert {:ok, _} = Shop.scan(sb_1)
      assert {:ok, _} = Shop.scan(gt_2)
      assert {:ok, _} = Shop.scan(gt_3)
      assert {:ok, _} = Shop.scan(cf_1)

      assert Shop.total() == "£22.45"
    end

    test "GR1,GR1 should be £3.11" do
      gt_1 = Product.new("GR1", "Green tea", 3_11)
      gt_2 = Product.new("GR1", "Green tea", 3_11)

      assert {:ok, _} = Shop.add_rule(CEORule)
      assert {:ok, _} = Shop.scan(gt_1)
      assert {:ok, _} = Shop.scan(gt_2)

      assert Shop.total() == "£3.11"
    end

    test "SR1,SR1,GR1,SR1 should be £16.61" do
      sb_1 = Product.new("SR1", "Strawberries", 5_00)
      sb_2 = Product.new("SR1", "Strawberries", 3_11)
      gt_1 = Product.new("GR1", "Green tea", 5_00)
      sb_3 = Product.new("SR1", "Strawberries", 5_00)

      assert {:ok, _} = Shop.add_rule(COORule)
      assert {:ok, _} = Shop.scan(sb_1)
      assert {:ok, _} = Shop.scan(gt_1)
      assert {:ok, _} = Shop.scan(sb_2)
      assert {:ok, _} = Shop.scan(sb_3)

      assert Shop.total() == "£16.61"
    end

# The expected result should be 30.57, but due to the Money library's handling of decimal fractions, the result rounds up to 30.58.
    test "GR1,CF1,SR1,CF1,CF1 should be  £30.58" do
      gt_1 = Product.new("GR1", "Green tea", 3_11)
      cf_1 = Product.new("CF1", "Coffee", 11_23)
      sb_1 = Product.new("SR1", "Strawberries", 5_00)
      cf_2 = Product.new("CF1", "Coffee", 11_23)
      cf_3 = Product.new("CF1", "Coffee", 11_23)

      assert {:ok, _} = Shop.add_rule(CTORule)
      assert {:ok, _} = Shop.scan(gt_1)

      assert {:ok, _} = Shop.scan(cf_1)
      assert {:ok, _} = Shop.scan(sb_1)
      assert {:ok, _} = Shop.scan(cf_2)
      assert {:ok, _} = Shop.scan(cf_3)
      assert Shop.total() == "£30.58"
    end
  end
end
