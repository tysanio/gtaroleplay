/*
Template: Glamorous - Responsive coming soon page   
Version 1.2
Author: The Theme Lab
Email: saif.shajib@gmail.com
AuthorUrl: http://themeforest.net/user/thethemelab 
*/


/* ==============================================
START PAGE SETINGS
=============================================== */

/* Background Overlay */
var bgOverlayImg = 'url(images/pattern-dark.png)'; //You may also set pattern-light.png here, if you need clear image.
var bgOverlayColor = '#000000';
var bgOverlayOpacity = '0.3'; // Set 0 if you do't need to overlay color

/*Background Image Settings (You can add more images with ',' separator)*/
var bgImages = [
    "images/bg1.jpg",
    "images/bg2.jpg",
    "images/bg3.jpg"
];
var slideFade = 1200; // 1.2 sec
var slideDuration = 9000; // 9sec

/* Title Rotator */
var rotate_options = {
		fx : 'scrollVert',
		timeout: 6000,
		delay: 1000,
		speed: 500,
		slides: '.rotate'
	};

/* COUNTDOWN 
Set up the date and time that will be counted down to*/
var launchDate = "10/01/2015 12:00:00"; //  your date MM/DD/YYYY HH:MM:SS
var offset = "+10";

/* ==============================================
END PAGE SETINGS
=============================================== */
var img='';                                      
for(var i=0; i<bgImages.length; i++)
img= img + '<img src="'+bgImages[i]+'" />';      
$('#kenburns-bg').prepend(img);

var overlayBackground = '';
if (bgOverlayImg.length > 0)
    overlayBackground = overlayBackground + bgOverlayImg + ' repeat ';
if (bgOverlayColor.length > 0) {
    var rgbColor = "rgba(" + hexToRgb(bgOverlayColor).r + "," + hexToRgb(bgOverlayColor).g + "," + hexToRgb(bgOverlayColor).b + "," + bgOverlayOpacity + ")";
    overlayBackground = overlayBackground + rgbColor;
}
if ($(".bg-overlay").length){
    $(".bg-overlay").css('background', overlayBackground);
    }


/*Onload function*/
$( window ).load(function(){
"use strict";
    if ($('html').hasClass('ie9')) {
        $('.herotext .top').css('display', 'none');
        $('.herotext .bottom').css('display', 'none');
    } else {
        $('.herotext .top').css('opacity', '0');
        $('.herotext .bottom').css('opacity', '0');
    }
// Add background for slideshow
   $("#kenburns-bg").kenburnsy({
       fullscreen: true,
       duration: slideDuration,
       fadeInDuration: slideFade
   });

   
    $("body").removeClass("preload");
	/* Preloader */
    $('#preload').delay(1500).fadeOut(1000, function() {
        animStart();
    });

    
    /* Count Down Time Settings*/
    $('.countdown').downCount({
        date: launchDate,
        offset: offset
    });

    //Scrollbar
    $('.wrapper').niceScroll({cursorcolor: "#ccc",cursorwidth: "10", cursoropacitymin: 0.6, background: "transparent", cursorborder: "0", autohidemode: true, cursorminheight: 30, zindex: 100, horizrailenabled: false });
    valign();


    /* ==============================================
    Tooltip Init
    =============================================== */
    $(".tip-top").tooltip({
        placement: 'top'
    });

});

    
/* ==============================================
Swiper Init
=============================================== */

var mySwiper = new Swiper('.swiper-container', {
    initialSlide: 1,
    keyboardControl: true,
    speed:1400, 
    progress:true,
       onProgressChange: function(swiper){
        for (var i = 0; i < swiper.slides.length; i++){
          var slide = swiper.slides[i];
          var progress = slide.progress;
          var rotate = -90*progress;
          if (rotate<-90) rotate=-90;
          if (rotate>90) rotate=90;
          var translate = progress*swiper.width/2;  
          var opacity = 1 - Math.min(Math.abs(progress),1);
          slide.style.opacity = opacity;
          swiper.setTransform(slide,'rotateY('+rotate+'deg) translate3d('+translate+'px,0,0)');
        }
      },
      onTouchStart:function(swiper){
        for (var i = 0; i < swiper.slides.length; i++){
          swiper.setTransition(swiper.slides[i], 0);
        }
      },
      onSetWrapperTransition: function(swiper, speed) {
        for (var i = 0; i < swiper.slides.length; i++){
          swiper.setTransition(swiper.slides[i], speed);
        }
      },
    onSlideChangeStart: function(swiper) {
        var activeSlide = swiper.activeSlide();
        var slideHeight = $(activeSlide).find('.slide-content')[0].offsetHeight;
        $('.swiper-container').css('height', slideHeight);
        $('.swiper-wrapper').css('height', slideHeight);
        //Scrollbar
        $('.wrapper').getNiceScroll().resize(); 
    }
});


$('.arrow-left').on('click', function(e) {
    e.preventDefault()
    mySwiper.swipePrev()
    return false;                       
});

$('.arrow-right').on('click', function(e) {
    e.preventDefault()
    mySwiper.swipeNext()
    return false;
});

$('.countdownDiv').on('click', function(e) {
    e.preventDefault();
    showContent('countdown');
    return false;
});

$('.countdownClose').on('click', function(e) {
    e.preventDefault();
    closeContent('countdown');
    return false;
});

$(window).resize(function() {
        swiperHeight();
    })


/**
 * Subscribe Form
 */
$('#subscribe-form').submit(function() {
    'use strict';
    // update user interface
    $('#response').html('<div class="loading"><span class="bounce1"></span><span class="bounce2"></span><span class="bounce3"></span><span class="bounce4"></span></div>');

    // Prepare query string and send AJAX request
    $.ajax({
        url: 'js/inc/store-address.php',
        data: 'ajax=true&email=' + escape($('#subscribe_email').val()),
        success: function(msg) {
            $('#response').html(msg).fadeIn(500);
            setTimeout(function() {
                        $('#response').html(msg).fadeOut(500);
                    }, 5000);
        }
    });

    return false;
});

/*Contact Form*/

$(document).ready(function() {
    'use strict';
    $('#contactForm').validatr({
        location: 'top',
        valid: function () {
        
    var form = $('#contactForm'); // contact form
    var submit = $('#contactForm_submit'); // submit button
    var alertx = $('.successMsg'); // alertx div for show alert message
    // form submit event
    // sending ajax request through jQuery
            $.ajax({
                url: 'js/inc/sendemail.php', // form action url
                type: 'POST', // form submit method get/post
                dataType: 'html', // request type html/json/xml
                data: form.serialize(), // serialize form data 
                beforeSend: function() {
                    alertx.fadeOut();
                    submit.html('Sending....'); // change submit button text
                },
                success: function(data) {
                    form.fadeOut(300);
                    alertx.html(data).fadeIn(1000); // fade in response data    
                    setTimeout(function() {
                        alertx.html(data).fadeOut(300);
                        $('#formName, #formEmail,#phone, #message').val('')
                        form.fadeIn(1800);
                    }, 4000);
                },
                error: function(e) {
                    console.log(e)
                }
            });
    return false;
    }
    }); 
});

function animStart() {
        $('.header-top').css('height', '80px');
        $('.header-bottom').css('height', '70px');
        $('.header-top .logo').css('opacity', '1').fadeIn(1000);
        $('#rotate').cycle(rotate_options);
    setTimeout(function() {
    if ($('html').hasClass('ie9')) {
        $('.herotext .top').fadeIn(1000);
        $('.herotext .bottom').fadeIn(1000);
    } else {
        $('.herotext .top').addClass('animated fadeInDown');
        $('.herotext .bottom').addClass('animated fadeInUp');
    } 
    }, 1000); 
}

function swiperHeight() {
    var activeSlide = mySwiper.activeSlide();
    var slideHeight = $(activeSlide).find('.slide-content')[0].offsetHeight;
    $('.swiper-container').css('height', slideHeight);
    $('.swiper-wrapper').css('height', slideHeight);   
    //ReInit Swiper
    mySwiper.reInit();
    valign();
}

function valign() {
         
    $('.main').css({
        'height': $(window).height()
    });                
    //Scrollbar
    $('.wrapper').getNiceScroll().resize();
}

var buttonClicked = false;
function showContent(content) {
  if(buttonClicked === false) {
		buttonClicked = true; 
    if ($('html').hasClass('ie9')) {
        var className = "." + content;
        $('.herotext .top').fadeOut(1000);
        $('.herotext .bottom').fadeOut(1000);

        setTimeout(function() {
            $(className).css('opacity', '1');
            $(className).fadeIn(1000);
        }, 1000);
    } else {
        var contentTop = "." + content + " .top";
        var contentBottom = "." + content + " .bottom";
        
        $(contentTop).css('opacity', '0');
        $(contentBottom).css('opacity', '0');

        $('.herotext .top').removeClass('fadeInDown').removeClass('fadeOutUp').addClass('animated fadeOutUp');
        $('.herotext .bottom').removeClass('fadeInUp').removeClass('fadeOutDown').addClass('animated fadeOutDown');
        
        function showSection() {
            var className = "." + content;

            $('.herotext .top').css('display', 'none').css('opacity', '0');
            $('.herotext .bottom').css('display', 'none').css('opacity', '0');
        
            $(className).css('display', 'block').removeClass('fadeOut').removeClass('fadeIn').addClass('animated fadeIn');

            $(contentTop).removeClass('fadeInDown').removeClass('fadeOutUp').addClass('animated fadeInDown');
            $(contentBottom).removeClass('fadeInUp').removeClass('fadeOutDown').addClass('animated fadeInUp');
       }
       setTimeout(showSection,1000);  
    }
 }
}

function closeContent(content) {
    buttonClicked = false;
    if ($('html').hasClass('ie9')) {
        var className = "." + content;    
        $(className).fadeOut(1000);

        setTimeout(function() {
            $('.herotext .top').fadeIn(1000);
            $('.herotext .bottom').fadeIn(1000);
        }, 1000);
    } else {
        var contentTop = "." + content + " .top";
        var contentBottom = "." + content + " .bottom";
        var className = "." + content;

        $(contentTop).removeClass('fadeInDown').removeClass('fadeOutUp').addClass('fadeOutUp');
        $(contentBottom).removeClass('fadeInUp').removeClass('fadeOutDown').addClass('fadeOutDown');
        $(className).removeClass('fadeOut').removeClass('fadeIn').addClass('fadeOut');
        function showHomeSection() {
            $(className).css('display', 'none');
            $('.herotext .top').css('display', 'block');
            $('.herotext .bottom').css('display', 'block');
  
            $('.herotext .top').removeClass('fadeInDown').removeClass('fadeOutUp').addClass('fadeInDown');
            $('.herotext .bottom').removeClass('fadeOutDown').removeClass('fadeInUp').addClass('fadeInUp');
        }
    setTimeout(showHomeSection,1000);
    }    
}