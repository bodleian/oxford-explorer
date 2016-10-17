class SuperfieldsController < ApplicationController

  def show
    @id = params[:id]
    @superfield = params[:superfield]


    thing_query = ThingQuery.new({@superfield => @id})

    @things_count = thing_query.things_count
    @things = thing_query.things
  end
end
