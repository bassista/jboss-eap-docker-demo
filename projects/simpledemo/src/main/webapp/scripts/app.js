var app = angular.module('simpledemo', [
    'ngCookies',
    'ngResource',
    'ngSanitize',
    'ngRoute'
]);
 
app.config(function ($routeProvider) {
    $routeProvider.when('/', {
        templateUrl: 'views/start.html',
        controller: 'SettingsCtrl'
    }).otherwise({
        redirectTo: '/'
    });
});


app.controller('SettingsCtrl', function ($scope, $http) {
	$http.get('rest/settings').success(function (data) {
    	$scope.settings=data;	
    }).error(function (data, status,headers) {
		if(status=403 && data.message.match("API rate limit exceeded")) {		
			$scope.alerts=[{type: 'danger', message: '<strong>API rate limit of GitHub exceeded.</strong> Try again at ' + new Date(headers('X-RateLimit-Reset') * 1000) + '.'}]
		} else if(status=503) {
			$scope.alerts=[{type: 'danger', message: '<strong>Back-end service in unavailable</strong>'}]
		} else {
			$scope.alerts=[{type: 'warning', message: '<strong>Server responsed with an error</strong>, status=' + status + ', message=' + data}]
		}
        console.log('Error data ' + data);
		console.log('Error data.message ' + data.message);
		console.log('Error status ' + status);
    });  
});
