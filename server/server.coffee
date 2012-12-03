Meteor.methods
  createGroup: ->
    unless @userId
      throw new Meteor.Error(403, "Not allowed")
    Groups.insert(name: "New Group", owner: @userId)

Meteor.publish "groups", ->
  Groups.find owner: @userId
Meteor.publish "standup_members", ->
  StandupMembers.find()

StandupMembers.allow
  insert: (userId, standupMember) ->
    !!standupMember?.name && !!standupMember?.group
