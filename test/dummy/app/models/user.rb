class User < ActiveRecord::Base
  has_many :articles
  enum gender: [:female, :male]
end
