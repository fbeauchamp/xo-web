'use strict'

angular.module('xoWebApp')
  .controller 'MainCtrl', ($scope, $location, stats, objects) ->
    $scope.stats = stats.stats

    $scope.byUUIDs = objects.byUUIDs
    $scope.hosts = objects.byTypes.host ? []
    $scope.pools = objects.byTypes.pool ? []
    $scope.SRs = objects.byTypes.SR ? []
    $scope.VMs = objects.byTypes.VM ? []

    $scope.goToSR = (uuid) ->
      $location.path "/srs/#{uuid}"

    $scope.goToVM = (uuid) ->
      $location.path "/vms/#{uuid}"

    # VMs checkboxes.
    do ->
      # This is the master checkbox.
      # Three states: true/false/null
      $scope.checked_master = false

      # This map marks which VMs are checked.
      $scope.checked_VMs = {}

      # Wheter all VMs are checked.
      $scope.all = false

      # Whether no VMs are checked.
      $scope.none = true

      # Extract some variables for performance and readability.
      {checked_VMs, VMs} = $scope

      # When we click on the master checkbox, we want to update the
      # `all` and `none` variables as well as each VMs.
      $scope.$watch 'checked_master', (checked_master) ->
        $scope.all = checked_master
        $scope.none = !checked_master

        checked_VMs[VM.$UUID] = checked_master for VM in VMs

      # When we click on a VM checkbox, we have to recompute the state
      # and update th `all` and `none` variables.
      $scope.$watchCollection 'checked_VMs', ->
        all = none = true
        i = 0

        for _, checked of checked_VMs
          ++i
          if checked
            none = false
            break unless all
          else
            all = false
            break unless none

        $scope.all = all && (i == VMs.length)
        $scope.none = none