var vizsubj;

$(document).on('click', '.buttonStyle', function () {
        Shiny.onInputChange('last_btn',this.id);
   });

$(document).on('click', '.buttonStyleCity', function () {
        Shiny.onInputChange('last_btnCity',this.id);
   });
      
$(document).on('click', '.buttonObj', function () {
        Shiny.onInputChange('last_Obj',this.id);
   });
   
$(document).on('click', '.buttonObjCty', function () {
        Shiny.onInputChange('last_ObjCty',this.id);
   });
  
  
$(document).on("shiny:inputchanged", function(event) {
               
                  alert(event);
               
              });
              

$(document).on('click', '.buttonStyleGraph', function () {
       //Shiny.onInputChange('lastGraph',this.id);
       
      changeSUbj();
      
   });

$(document).on('click', '.BuGraphIcu', function () {
        Shiny.onInputChange('lastGraphICU',this.id);
   });
  
$(document).on('click', '.buttonStyleGraphCity', function () {
        Shiny.onInputChange('lastGraphCity',this.id);
   });

$(document).on('click', '.buttonStyleGraphObj', function () {
        Shiny.onInputChange('lastGraphObj',this.id);
   });
   
$(document).on('click', '.buttonStyleGraphObjCiud', function () {
        Shiny.onInputChange('lastGraphObjC',this.id);
   });

$(document).on('click', '.temasComunes', function () {
        Shiny.onInputChange('lastTemaComun',this.id);
   });


$(document).on('click', '.buttonStyleCruces', function () {
        Shiny.onInputChange('last_cruce',this.id);
   });


$(document).on('click', '.buttonStyleODS', function () {
        Shiny.onInputChange('last_ods',this.id);
   });

$(document).ready(function(){
  
  
  $("#VariablesSubjetivos").on('change', function(){
    alert('change');
     changeSUbj();
    
  });
  
  $(document).on("click", ".buttonStyle,.buttonStyleCity, .buttonObj, .buttonObjCty,.buttonStyleCruces", function(evt) {
	  $(".buttonStyle,.buttonStyleCity,.buttonObj,.buttonObjCty,.buttonStyleCruces").css('background-color', '#26327E');
	    const btnActual = evt.target;
	    const img = $(btnActual).find('.cosa');
	    if (img) {
        $('.cosa').removeClass('inverse');
	      $(img).addClass('inverse');
	    }
	    $(".buttonStyle,.buttonStyleCity,.buttonObj,.buttonObjCty,.buttonStyleCruces").css('color', '#fff');
      $(this).css('background-color', '#D8E13E');
      $(this).css('color', '#26327E');
    });

});


function changeSUbj(){
  
  console.log($("#VariablesSubjetivos").val());
   
       var containerDiv = document.getElementById("VizSubj"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja1?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                            "Name": $("#VariablesSubjetivos").val(),
                            "AÑO (Anio)": $("#anioSubjSel").val(),
                            onFirstInteractive: function () {

                            }
                        };
                    vizsubj = new tableau.Viz(containerDiv, url, options);
  
}



   /*
   
   $(this).addClass('pressed');
   
   const cosas = document.querySelectorAll('.cosa')
   const cosasArray = Array.prototype.slice.call(cosas)
 	      cosasArray.forEach((cosa) => cosa.addEventListener('click', changecosaColor))
 
 		      function changecosaColor (event) {
 			    cosasArray.forEach(cosa => cosa.classList.remove('inverse'))
 			    event.target.classList.add('inverse')
 		                                       }*/