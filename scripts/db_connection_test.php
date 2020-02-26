<?php

$host     = 'dev';
$user     = 'dev';
$pass     = 'pass';
$database = 'dev';

/* mysqli�̏ꍇ
$mysqli = new mysqli($host, $user, $pass, $database);

if ($mysqli->connect_error) {
	echo $mysqli->connect_error;
	exit();
} else {
	$mysqli->set_charset("utf8");
}

$sql = 'select now()';
$res = $mysqli->query($sql);

if( $res ) {
	var_dump($res->fetch_all());
}

$mysqli->close();
*/

try{
	//DB��I�����ăR�l�N�g
	$db_perm = array(
			PDO::ATTR_EMULATE_PREPARES => false,
			PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION
		);
	$link = new PDO('mysql:host='. $host .'; dbname='. $database .'; charset=utf8', $user, $pass, $db_perm);

	//SELECT���𔭍s
	$sql = 'select now()';
	$stmt = $link->query($sql);
	$result = $stmt->fetchAll();
	var_dump($result);

	//�ڑ����N���[�Y
	$result = null;
	$link = null;

} catch( PDOException $e) {
	$db_error = $e->getMessage();
	error_log($db_error);
	print 'DB�G���[: ' . $db_error  .'<br>' ;
	die($db_error);
}
