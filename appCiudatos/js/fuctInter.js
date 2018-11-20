var vizsubj;
var vizLine;
var vizStackCiudad;
var vizTreemap;
var vizLineObj;
var vizStackObj;
var vizTreemapObj;
var currentButton = 'linea';
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
               
                  //console.log(event);
                  if(event.name=='VariablesSubjetivos' || event.name=='anioSubjSel'){
                     changeSUbj();
                  }
                  
                  
                  if(event.name=='varCiudadSubjSel' || event.name=='ciudadSubj'){
                     changeSUbjCiudad();
                  }
                  
                   if(event.name=='VariablesObjtivos'){
                     changeObj();
                  }
               
  });
              

$(document).on('click', '.buttonStyleGraph', function () {
       //Shiny.onInputChange('lastGraph',this.id);
       console.log('chanheeee');
      changeSUbj();
      
   });


  
$(document).on('click', '.BuGraphIcu', function () {
        Shiny.onInputChange('lastGraphICU',this.id);
   });
  
$(document).on('click', '.buttonStyleGraphCity', function () {
        Shiny.onInputChange('lastGraphCity',this.id);
        currentButton = this.id;
        
        if(vizLine !=undefined)
        {
         vizLine.dispose();
         vizLine = undefined;
        }
        if(vizStackCiudad !=undefined){
                vizStackCiudad.dispose();
                vizStackCiudad = undefined;
        }
        
         if(vizTreemap !=undefined){
                vizTreemap.dispose();
                vizTreemap = undefined;
        }
        
        $("#VizSubjCity").html('');
      
        changeSUbjCiudad();
        
        console.log(currentButton);
        
   });

$(document).on('click', '.buttonStyleGraphObj', function () {
        Shiny.onInputChange('lastGraphObj',this.id);
        
        currentButton = this.id;
        
        if(vizLineObj !=undefined)
        {
         vizLineObj.dispose();
         vizLineObj = undefined;
        }
        if(vizStackObj !=undefined){
                vizStackObj.dispose();
                vizStackObj = undefined;
        }
        
         if(vizTreemapObj !=undefined){
                vizTreemapObj.dispose();
                vizTreemapObj = undefined;
        }
        
        $("#VizObj").html('');
      
        changeObj();
        
        
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
    if (vizsubj == null) {
       var containerDiv = document.getElementById("VizSubj"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja1?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                            "Name": $("#VariablesSubjetivos").val(),
                            //"AÑO(Anio)": $("#anioSubjSel").val(),
                            onFirstInteractive: function () {

                                  changeSUbj();
                            }
                        };
                    vizsubj = new tableau.Viz(containerDiv, url, options);
    }else{
         var sheet = vizsubj.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#VariablesSubjetivos").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             fieldname = "AÑO(Anio)";
            value = $("#anioSubjSel").val();
            
             if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
           
    }
  
}

function changeSUbjCiudad(){
  
  
  
  if(currentButton=='linea'){
    
    console.log(vizLine);
    if (vizLine == null || vizLine==undefined) {
       var containerDiv = document.getElementById("VizSubjCity"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja2?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                           onFirstInteractive: function () {
                               changeSUbjCiudad();
                                                      
                            }
                        };
                    vizLine = new tableau.Viz(containerDiv, url, options);
    }else{
         console.log($("#ciudadSubj").val());
         console.log($("#varCiudadSubjSel").val());
         var sheet = vizLine.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#varCiudadSubjSel").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             fieldname = "Ciudad";
            value = $("#ciudadSubj").val();
            
             if (value !== "") {
                sheet.applyFilterAsync(fieldname, value.toUpperCase(), tableau.FilterUpdateType.REPLACE);
            }
           
    }
  }
  
  
    
    
    
    if(currentButton=='barras'){
      
      console.log('son barras');
    console.log(vizStackCiudad);
    if (vizStackCiudad == null || vizStackCiudad==undefined) {
       var containerDiv = document.getElementById("VizSubjCity"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja3?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                           onFirstInteractive: function () {
                               changeSUbjCiudad();
                                                      
                            }
                        };
                    vizStackCiudad = new tableau.Viz(containerDiv, url, options);
    }else{
         console.log($("#ciudadSubj").val());
         console.log($("#varCiudadSubjSel").val());
         var sheet = vizStackCiudad.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#varCiudadSubjSel").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             fieldname = "Ciudad";
            value = $("#ciudadSubj").val();
            
             if (value !== "") {
                sheet.applyFilterAsync(fieldname, value.toUpperCase(), tableau.FilterUpdateType.REPLACE);
            }
           
     }
    }
    
    
    
    
    if(currentButton=='treemap'){
      
   
    if (vizTreemap == null || vizTreemap==undefined) {
       var containerDiv = document.getElementById("VizSubjCity"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja4?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                           onFirstInteractive: function () {
                               changeSUbjCiudad();
                                                      
                            }
                        };
                    vizTreemap = new tableau.Viz(containerDiv, url, options);
    }else{
         console.log($("#ciudadSubj").val());
         console.log($("#varCiudadSubjSel").val());
         var sheet = vizTreemap.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#varCiudadSubjSel").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             fieldname = "Ciudad";
            value = $("#ciudadSubj").val();
            
             if (value !== "") {
                sheet.applyFilterAsync(fieldname, value.toUpperCase(), tableau.FilterUpdateType.REPLACE);
            }
           
     }
    }
  
}




function changeObj(){
  
  console.log(currentButton);
  
  if(currentButton=='linea'){
    
  
      if (vizLineObj == null || vizLineObj==undefined) {
         var containerDiv = document.getElementById("VizObj"),
                          url = "https://public.tableau.com/views/CiudatosGraficos/Hoja2?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
  
                             onFirstInteractive: function () {
                                 changeObj();
                                                        
                              }
                          };
                      vizLineObj = new tableau.Viz(containerDiv, url, options);
      }else{
          
           var sheet = vizLineObj.getWorkbook().getActiveSheet();
              var fieldname = "Name";
              var value = $("#VariablesObjtivos").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
              
             
      }
  }
  
  
    
    
    
    if(currentButton=='barras'){
      
        console.log('son barras');
      console.log(vizStackCiudad);
      if (vizStackCiudad == null || vizStackCiudad==undefined) {
         var containerDiv = document.getElementById("VizSubjCity"),
                          url = "https://public.tableau.com/views/CiudatosGraficos/Hoja3?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
  
                             onFirstInteractive: function () {
                                 changeSUbjCiudad();
                                                        
                              }
                          };
                      vizStackCiudad = new tableau.Viz(containerDiv, url, options);
      }else{
           console.log($("#ciudadSubj").val());
           console.log($("#varCiudadSubjSel").val());
           var sheet = vizStackCiudad.getWorkbook().getActiveSheet();
              var fieldname = "Name";
              var value = $("#varCiudadSubjSel").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
               fieldname = "Ciudad";
              value = $("#ciudadSubj").val();
              
               if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value.toUpperCase(), tableau.FilterUpdateType.REPLACE);
              }
             
       }
    }
    
    
    
    
    if(currentButton=='treemap'){
      
   
      if (vizTreemap == null || vizTreemap==undefined) {
         var containerDiv = document.getElementById("VizSubjCity"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja1?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
  
                             onFirstInteractive: function () {
                                 changeSUbjCiudad();
                                                        
                              }
                          };
                      vizTreemap = new tableau.Viz(containerDiv, url, options);
      }else{
           console.log($("#ciudadSubj").val());
           console.log($("#varCiudadSubjSel").val());
           var sheet = vizTreemap.getWorkbook().getActiveSheet();
              var fieldname = "Name";
              var value = $("#varCiudadSubjSel").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
               fieldname = "Ciudad";
              value = $("#ciudadSubj").val();
              
               if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value.toUpperCase(), tableau.FilterUpdateType.REPLACE);
              }
             
       }
    }
  
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