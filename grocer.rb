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
  cart = consolidate_cart(cart: item)
  cart_w_coupons = apply_coupons(cart: cart, coupons: coupons)
  clearance_cart = apply_clearance(cart: cart)
  result = 0
  clearance_cart.each do |food, info|
    result += (info[:price] * info[:count]).to_f
  end
  result > 100 ? result * 0.9 : result
end