class Thing

  ES_CLIENT = Elasticsearch::Client.new url: ENV.fetch('ELASTICSEARCH_URL'), log: false

  attr_reader :metadata, :title, :id, :description

  def initialize(metadata)
    @metadata = metadata
    @title = Array(metadata['gfs_title']).first || '(untitled)'
    @description = Array(metadata['gfs_description']).first
    @id = metadata['gfs_id']
  end

  def [](key)
    @metadata[key]
  end

  def authors
    return [] unless @metadata['gfs_author']

    return Array(@metadata['gfs_author']) if @metadata['gfs_author'].is_a?(String)

    @authors ||= @metadata['gfs_author'].compact.reject(&:blank?)

  end

  def subjects
    return [] unless @metadata['gfs_subject']

    return Array(@metadata['gfs_subject']) if @metadata['gfs_subject'].is_a?(String)

    @subjects ||= @metadata['gfs_subject'].compact.reject(&:blank?)
  end

  def types_of_things
    return [] unless @metadata['gfs_item_type']

    return Array(TypeOfThing.find(@metadata['gfs_item_type'])) if @metadata['gfs_item_type'].is_a?(String)

    @types_of_things ||= @metadata['gfs_item_type'].compact.reject(&:blank?).collect do |item_type|
      TypeOfThing.find(item_type)
    end
  end

  def self.find(id)
    thing = ES_CLIENT.get index: 'dev', type: 'record', id: id
    self.new(thing['_source'])
  end

end
