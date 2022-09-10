x
class Song

  attr_accessor :name, :album, :id

  def initialize(name:, album:, id: nil)
    @id = id
    @name = name
    @album = album
  end

  # class method to create a table (with matching column_names to Class attributes) and establish connection to Database
  def self.create_table
    sql = %Q(
      CREATE TABLE IF NOT EXISTS songs(
        id INTEGER PRIMARY KEY,
        name TEXT,
        album TEXT
      )
      )
      DB[:conn].execute(sql)
  end

  # instance method that saves attributes of Song Instances to Database.

  def save 
    sql = %Q(
    INSERT INTO songs (name, album)
    VALUES (?, ?)
    )
    DB[:conn].execute(sql, self.name, self.album)

    # get the song ID from the database and save it to the Ruby instance
    self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM songs")[0][0]

    # return the Ruby instance (object)
    self
  end

  def self.create(name:, album:)
    song = Song.new(name: name, album: album)
    song.save
  end


end
