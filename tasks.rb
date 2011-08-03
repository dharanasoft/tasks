# the idea is to have a list of tasks
# each task has a title, status
# support due_date and tags for tasks
$:.unshift(".")
require 'yaml'
require 'persistence'
require 'colorize'
class Task
  include Persistence
  attr_accessor :title, :status, :tags
  def initialize(title)
    @title = title
    @tags = []
  end
  def tag(tag_name)
    @tags ||= []
    @tags << tag_name
    self
  end
  def complete
    @status = :complete
    self
  end
  def to_hashtags
    @tags.map {|t| "##{t}"}.join(" ")
  end
  def to_s
    "#{'[done] ' if @status==:complete}#{@title} #{to_hashtags}"
  end
  def inspect
    to_s
  end
  def self.by_tag(tag)
    collection.find_all { |t| t.tags.index(tag) }
  end
  def self.complete_by_tag(tag)
    by_tag(tag).map { |t| t.complete }
  end
  def self.create(title)
    t = Task.new(title)
    collection << t
    t
  end
end
