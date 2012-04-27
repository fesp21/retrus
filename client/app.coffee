Retrospectives = new Meteor.Collection("retrospectives")

Meteor.subscribe 'retrospectives', ->

Template.home.show = ->
  !Session.get "currentRetrospective"

Template.retrospectives_list.retrospectives = ->
  Retrospectives.find()

Template.createRetrospective.events =
  submit: ->
    id = Retrospectives.insert
      name: $("#new-retrospective-name").val()
    Router.setRetrospectiveFacilitator id

AppRouter = Backbone.Router.extend
  routes:
    "": "root"
    "retrospectives/:retrospective_id/facilitator": "retrospectiveFacilitator"
    "retrospectives/:retrospective_id": "retrospective"

  root: ->
    Session.set "currentRetrospective", null

  retrospectiveFacilitator: (retrospective_id) ->
    Session.set "facilitating", true
    Session.set "currentRetrospective", retrospective_id

  retrospective: (retrospective_id) ->
    Session.set "facilitating", false
    Session.set "currentRetrospective", retrospective_id

  setHome: ->
    @navigate "", true
  setRetrospective: (retrospective_id) ->
    @navigate "retrospectives/#{retrospective_id}", true
  setRetrospectiveFacilitator: (retrospective_id) ->
    @navigate "retrospectives/#{retrospective_id}/facilitator", true

this.Router = new AppRouter

Meteor.startup ->
  Backbone.history.start({ pushState: true })