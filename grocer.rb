def consolidate_cart(cart)
  my_cart = {}
  count = 0
  cart.each do |item|
    item.each do |food, info|
      if my_cart[food]
        my_cart[food][:count] +=1
      else
        my_cart[food] = info
        my_cart[food][:count] = 1
      end
    end
  end
 my_cart
end

def apply_coupons(cart, coupons)
  coupons.each do |coupon|
    if cart.has_key?(coupon[:item]) && cart[coupon[:item]][:count] >= coupon[:num]
      cart[coupon[:item]][:count] -= coupon[:num]
      new_name = "#{coupon[:item]} W/COUPON"
      if cart.has_key?(new_name)
        cart[new_name][:count] += coupon[:num]
      else
        cart[new_name] = {
          count: coupon[:num],
          price: coupon[:cost] / coupon[:num],
          clearance: cart[coupon[:item]][:clearance]
        }
      end
    end
  end
  return cart
end

def apply_clearance(cart)
  clearance_cart = {}
  cart.each do |food, info|
  clearance_cart[food] ={}
    if info[:clearance] == true 
      clearance_cart[food][:price] = info[:price] * 4/5
    else
      clearance_cart[food][:price] = info[:price]
    end
    clearance_cart[food][:clearance] = info[:clearance]
    clearance_cart[food][:count] = info[:count]
  end
  clearance_cart
end

def checkout(cart, coupons)
  consolidate_cart(cart)
  apply_coupons(cart, coupons)
  apply_clearance(cart)

  total = cart.reduce(0) do | memo, (key, value) |
    if !memo
      memo = value[:price][0]
    else
      memo += value[:price]
    end
    memo
  end
  if total >= 100
    total = total * 0.9
  end

  return total
end