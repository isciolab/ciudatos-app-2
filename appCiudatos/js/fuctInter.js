var vizsubj;
var vizLine;
var vizStackCiudad;
var vizTreemap;
var vizLineObj;
var vizStackObj;
var vizTreemapObj;
var vizmapaObj;
var vizLineObjC;
var vizStackObjC;
var vizLineObjCruces;
var vizLineSubjCruces;
var vizLineSubjCrucesDS;
var vizLineObjCrucesDS;
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
                  if(event.name=='VariablesSubjetivos' ){
                     changeSUbj();
                  }
                  
                  
                  if(event.name=='varCiudadSubjSel' || event.name=='ciudadSubj'){
                     changeSUbjCiudad();
                  }
                  
                   if(event.name=='VariablesObjtivos'){
                     changeObj();
                  }
               
                if(event.name=='varObjCiudadE'){
                     changeObjC();
                  }
                  
                if(event.name=='SelvarElgC'){
                  
                  if(vizLineObjCruces!=undefined){
                      vizLineObjCruces.dispose();
                      vizLineObjCruces = undefined;
                  }
                  if(vizLineSubjCruces!=undefined){
                      vizLineSubjCruces.dispose();
                      vizLineSubjCruces = undefined;
                  }
        
                  $("#grafCrucesD").html('');
                 setTimeout(function(){ 
                   var tipo=$("#grafCrucesDHidden").text();
                    console.log(tipo);
                    if(tipo=='obj'){
                       changeObjCruces();
                    }else{
                      changeSubjCruces();
                    } }, 3000);
                    
                    
                }
                
                if(event.name=='SelSegVar'){
                  if(vizLineObjCrucesDS!=undefined){
                      vizLineObjCrucesDS.dispose();
                      vizLineObjCrucesDS = undefined;
                  }
                  if(vizLineSubjCrucesDS!=undefined){
                      vizLineSubjCrucesDS.dispose();
                      vizLineSubjCrucesDS = undefined;
                  }
        
       
               $("#grafCrucesDS").html('');
        
                 setTimeout(function(){ 
                   var tipo=$("#grafCrucesDHidden").text();
                     var tipo=$("#grafCrucesDSHidden").text();
                    if(tipo=='obj'){
                       changeObjCrucesDS();
                    }else{
                      changeSubjCrucesDS();
                    } }, 3000);
                    
                    
                 
                   
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
        
         if(vizmapaObj !=undefined){
                vizmapaObj.dispose();
                vizmapaObj = undefined;
        }
        
        $("#VizObj").html('');
      
        changeObj();
        
        
   });
   
   
   
$(document).on('click', '.buttonStyleGraphObjCiud', function () {
        Shiny.onInputChange('lastGraphObjC',this.id);
        
        
         currentButton = this.id;
        
        if(vizLineObjC !=undefined)
        {
         vizLineObjC.dispose();
         vizLineObjC = undefined;
        }
        if(vizStackObjC !=undefined){
                vizStackObjC.dispose();
                vizStackObjC = undefined;
        }
        
        
        $("#VizObjCif").html('');
      
        changeObjC();
        
        
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
             
           
    }
  
}

function changeSUbjCiudad(){
  
  
  
  if(currentButton=='linea'){
    
    
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
        
         var sheet = vizLine.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#varCiudadSubjSel").val();
           console.log(value);
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             fieldname = "City";
            value = $("#ciudadSubj").val();
            console.log(value);
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
             fieldname = "City";
            value = $("#ciudadSubj").val();
            
             if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
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
             fieldname = "City";
            value = $("#ciudadSubj").val();
            
             if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
           
     }
    }
  
}




function changeObj(){
  
  console.log(currentButton);
  
  if(currentButton=='linea'){
    
  
      if (vizLineObj == null || vizLineObj==undefined) {
         var containerDiv = document.getElementById("VizObj"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja1?:embed=y&:display_count=yes&publish=yes",
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
      console.log(vizStackObj);
      if (vizStackObj == null || vizStackObj==undefined) {
         var containerDiv = document.getElementById("VizObj"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja3?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
  
                             onFirstInteractive: function () {
                                 changeSUbjCiudad();
                                                        
                              }
                          };
                      vizStackObj = new tableau.Viz(containerDiv, url, options);
      }else{
          
           var sheet = vizStackObj.getWorkbook().getActiveSheet();
              var fieldname = "Name";
              var value = $("#VariablesObjtivos").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
               
             
       }
    }
    
    
    
    
    if(currentButton=='treemap'){
      
   
      if (vizTreemapObj == null || vizTreemapObj==undefined) {
         var containerDiv = document.getElementById("VizObj"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja2?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
  
                             onFirstInteractive: function () {
                                 changeSUbjCiudad();
                                                        
                              }
                          };
                      vizTreemapObj = new tableau.Viz(containerDiv, url, options);
      }else{
           
           var sheet = vizTreemapObj.getWorkbook().getActiveSheet();
              var fieldname = "Name";
              var value = $("#VariablesObjtivos").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
              
             
       }
    }
    
    
    
    
    if(currentButton=='mapa'){
      
   
      if (vizmapaObj == null || vizmapaObj==undefined) {
         var containerDiv = document.getElementById("VizObj"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja4?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
  
                             onFirstInteractive: function () {
                                 changeSUbjCiudad();
                                                        
                              }
                          };
                      vizmapaObj = new tableau.Viz(containerDiv, url, options);
      }else{
         
           var sheet = vizmapaObj.getWorkbook().getActiveSheet();
              var fieldname = "Name";
              var value = $("#VariablesObjtivos").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
              
             
       }
    }
  
}






function changeObjC(){
  
  console.log(currentButton);
  
  if(currentButton=='linea'){
    
  
      if (vizLineObjC == null || vizLineObjC==undefined) {
         var containerDiv = document.getElementById("VizObjCif"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja5?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
  
                             onFirstInteractive: function () {
                                 changeObj();
                                                        
                              }
                          };
                      vizLineObjC = new tableau.Viz(containerDiv, url, options);
      }else{
          
           var sheet = vizLineObjC.getWorkbook().getActiveSheet();
              var fieldname = "Name";
              var value = $("#varObjCiudadE").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
              var fieldname = "City";
              var value = $("#ciudadObjD").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
              
             
      }
  }
  
  
    
    
    
    if(currentButton=='barras'){
      
        console.log('son barras');
     
      if (vizStackObjC == null || vizStackObjC==undefined) {
         var containerDiv = document.getElementById("VizObjCif"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja6?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
  
                             onFirstInteractive: function () {
                                 changeSUbjCiudad();
                                                        
                              }
                          };
                      vizStackObjC = new tableau.Viz(containerDiv, url, options);
      }else{
          
           var sheet = vizStackObjC.getWorkbook().getActiveSheet();
              var fieldname = "Name";
              var value = $("#varObjCiudadE").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
              
              var fieldname = "City";
              var value = $("#ciudadObjD").val();
             
              if (value !== "") {
                  sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
              }
              
               
             
       }
    }
    
    
    
    
  
}


function changeObjCruces(){
  
 
 
 
    
    if (vizLineObjCruces == null) {
       var containerDiv = document.getElementById("grafCrucesD"),
                        url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja5?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                            
                            onFirstInteractive: function () {

                                  changeObjCruces();
                            }
                        };
                    vizLineObjCruces = new tableau.Viz(containerDiv, url, options);
    }else{
         var sheet = vizLineObjCruces.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#SelvarElgC").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             var fieldname = "City";
            var value = $("#ciudadOpCru").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             
           
    }
    
  
   
    
    
  
}


function changeSubjCruces(){
  
 
 
 
    
    if (vizLineSubjCruces == null) {
       var containerDiv = document.getElementById("grafCrucesD"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja2?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                            
                            onFirstInteractive: function () {

                                  changeSubjCruces();
                            }
                        };
                    vizLineSubjCruces = new tableau.Viz(containerDiv, url, options);
    }else{
         var sheet = vizLineSubjCruces.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#SelvarElgC").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
            var fieldname = "City";
            var value = $("#ciudadOpCru").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             
           
    }
    
  
   
    
    
  
}




function changeObjCrucesDS(){
  
 
 
 
    
    if (vizLineObjCrucesDS == null) {
       var containerDiv = document.getElementById("grafCrucesDS"),
                        url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja5?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                            
                            onFirstInteractive: function () {

                                  changeObjCrucesDS();
                            }
                        };
                    vizLineObjCrucesDS = new tableau.Viz(containerDiv, url, options);
    }else{
         var sheet = vizLineObjCrucesDS.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#SelSegVar").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             var fieldname = "City";
            var value = $("#ciudadOpCru").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             
           
    }
    
  
   
    
    
  
}


function changeSubjCrucesDS(){
  
 
 
 
    
    if (vizLineSubjCrucesDS == null) {
       var containerDiv = document.getElementById("grafCrucesDS"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja2?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,

                            
                            onFirstInteractive: function () {

                                  changeSubjCrucesDS();
                            }
                        };
                    vizLineSubjCrucesDS = new tableau.Viz(containerDiv, url, options);
    }else{
         var sheet = vizLineSubjCrucesDS.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#SelSegVar").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
            var fieldname = "City";
            var value = $("#ciudadOpCru").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
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