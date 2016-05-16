class User < ActiveRecord::Base
  has_many :articles
  enum gender: {female: 0, male: 1}

  def self.restricted_statuses
    statuses.except :failed, :destroyed
  end
end
