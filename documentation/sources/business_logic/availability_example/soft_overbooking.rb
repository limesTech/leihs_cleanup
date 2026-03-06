module Example
  @r5 = FactoryGirl.create(:reservation, model: @model, status: :approved, user: @user_C, inventory_pool: @pool,
                           start_date: Date.parse('2018-07-10'), end_date: Date.parse('2018-07-11'))
end
