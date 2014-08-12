ActiveRecord::Base.establish_connection({
    adapter: "sqlite3",
    dbfile:  "users.sqlite",
    database:"db/test.sqlite3"
})

begin
  ActiveRecord::Schema.drop_table('users')
rescue
  nil
end

ActiveRecord::Schema.define(:version => 0) do
  create_table :users do |t|
    t.string :name, :email, :access_token, :itu_id
  end
end
