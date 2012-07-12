class Phone
  include MongoMapper::Document

  # key <name>, <type>
  key :name, String
  key :number, String
  key :active, Boolean
  key :account_id, ObjectId 
  timestamps!

  belongs_to :account
end
