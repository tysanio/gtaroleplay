<?php
define("server","localhost");
define("user","root");
define("password","yfhghfhgfghfgh");
define("db","samp2");
define("site_name","hgfhgfghfvhnfvhvv");
define("root_folder",dirname(__File__)."/");

function clean($string) {
   $string = str_replace('_', ' ', $string); // Replaces all spaces with hyphens.

   return preg_replace('/[^A-Za-z0-9\-]/', ' ', $string); // Removes special chars.
}
?>
