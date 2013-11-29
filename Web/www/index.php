<?php
error_reporting(E_ALL);
ini_set('display_errors', true);
define('PROJECT_DIR', realpath(__DIR__.'/../').'/');
$loader = require_once(PROJECT_DIR.'vendor/autoload.php');

lmbLoader::addIncludePath(PROJECT_DIR);
lmbLoader::load('src/Person.php');

SonDb::$public_dir = PROJECT_DIR.'/www/';

$router = new \Klein\Klein();

$router->get('/', function($request, $response)
{
	$host = $_SERVER['HTTP_HOST'];
	$content =<<<EOD
<h1>API</h1>

<h3>Check in:</h3>
<textarea cols="80" rows="3">curl -d "name=Никита Джигурда&website=https://www.facebook.com/dzhigurda12&userpic=http://bit.ly/1jPWzmz" http://{$host}/persons/foobar42.json</textarea>

<h3>Check out:</h3>
<textarea cols="80">curl -X DELETE http://{$host}/persons/foobar42.json</textarea>

<h3>Checked in users:</h3>
<textarea cols="80">curl http://{$host}/persons.json</textarea>
EOD;
	return $content;
});

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

	return $response->json(['success' => true]);
});

$router->delete('/persons/[*:hash].json', function($request, $response)
{
	$persons = Person::load();
	unset($persons[$request->hash]);
	$persons->save();

	return $response->json(['success' => true]);
});

$router->dispatch();

