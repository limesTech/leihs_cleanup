module Example
  @model = FactoryGirl.create(:model, product: 'Example Model')
  @pool = FactoryGirl.create(:inventory_pool)

  @inventory_manager = FactoryGirl.create(:inventory_manager,
                                          inventory_pool: @pool,
                                          email: 'inventory_manager@example.com')

  4.times { FactoryGirl.create(:item, model: @model, inventory_pool: @pool) }

  @group_1 = FactoryGirl.create(:group, inventory_pool: @pool, name: 'Group 1')
  @group_2 = FactoryGirl.create(:group, inventory_pool: @pool, name: 'Group 2')

  FactoryGirl.create(:entitlement, model: @model, entitlement_group: @group_1, quantity: 2)
  FactoryGirl.create(:entitlement, model: @model, entitlement_group: @group_2, quantity: 1)

  @user_A = FactoryGirl.create(:customer, inventory_pool: @pool, email: 'user_a@example.com',
                               firstname: 'User', lastname: 'A') 
  @group_1.users << @user_A
  @group_2.users << @user_A

  @user_B = FactoryGirl.create(:customer, inventory_pool: @pool, email: 'user_b@example.com',
                               firstname: 'User', lastname: 'B') 
  @group_2.users << @user_B

  @user_C = FactoryGirl.create(:customer, inventory_pool: @pool, email: 'user_c@example.com',
                               firstname: 'User', lastname: 'C') 

  # Timecop.travel('2018-06-27') # personas travel date

  @r1 = FactoryGirl.create(:reservation, model: @model, status: :approved, user: @user_A, inventory_pool: @pool,
                           start_date: Date.parse('2018-06-26'), end_date: Date.parse('2018-07-05'))
  @r2 = FactoryGirl.create(:reservation, model: @model, status: :approved, user: @user_B, inventory_pool: @pool,
                           start_date: Date.parse('2018-06-27'), end_date: Date.parse('2018-06-28'))
  @r3 = FactoryGirl.create(:reservation, model: @model, status: :approved, user: @user_C, inventory_pool: @pool,
                           start_date: Date.parse('2018-06-27'), end_date: Date.parse('2018-07-11'))
  @r4 = FactoryGirl.create(:reservation, model: @model, status: :approved, user: @user_A, inventory_pool: @pool,
                           start_date: Date.parse('2018-07-02'), end_date: Date.parse('2018-07-03'))
end
