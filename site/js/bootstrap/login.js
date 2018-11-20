$(function(){

    $("#login-form").submit(function() {
        event.preventDefault();

        var name = $('#inputName').val();
        var password = $('#inputPassword').val();

        $.post("ucp.php", 
        {
            name: name,
            password: password
        },
        function(data)
        {
            if(data.result == 'false') {
                $("#resultDiv").html('<div class="alert alert-danger" style="margin-top:25px; margin-bottom: 0px; text-align:center;">Invalid <strong>username</strong> or <strong>password</strong>.</div>').fadeIn(1000).effect( "shake", {direction:"up",times:2, distance:10}, 750 );
            } else if (data.result == 'true'){
                window.location = "choose.php";
            }
        }, "json");
    });

    $(".container").fadeIn(500);
});
