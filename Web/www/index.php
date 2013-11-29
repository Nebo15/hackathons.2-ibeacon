<?php
error_reporting(E_ALL);
ini_set('display_errors', true);
define('PROJECT_DIR', realpath(__DIR__.'/../').'/');
$loader = require_once(PROJECT_DIR.'vendor/autoload.php');

lmbLoader::addIncludePath(PROJECT_DIR);
lmbLoader::load('src/Person.php');

SonDb::$public_dir = PROJECT_DIR.'/www/';

$router = new \Klein\Klein();
/*
curl -d "name=Никита Джигурда&website=https://www.facebook.com/dzhigurda12&userpic=http://bit.ly/1jPWzmz" http://hackaton.2-ibeacon.dev/persons/foobar42.json
*/
$router->post('/persons/[*:hash].json', function($request, $response)
{
	$person = new Person;
	$person->name = $request->name;
	$person->website = $request->website;
	$person->userpic = $request->userpic;
	$person->last_login_stamp = time();

	$persons = Person::load();
	$persons[$request->hash] = $person;
	$persons->save();

	return $response->json(true);
});

/*
curl -X DELETE http://hackaton.2-ibeacon.dev/persons/foobar42.json
*/
$router->delete('/persons/[*:hash].json', function($request, $response)
{
	$persons = Person::load();
	unset($persons[$request->hash]);
	$persons->save();

	return $response->json(true);
});

/*
curl http://hackaton.2-ibeacon.dev/persons.json
*/

$router->dispatch();

