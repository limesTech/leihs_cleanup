module Example
  @model.items.take(2).each do |i|
    i.update_attributes! \
      retired: Date.today,
      retired_reason: Faker::Lorem.sentence
  end
end
