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
var vizLineObjCrucesTema;
var vizLineSubjCrucesTema;

var vizLineObjCrucesDS;

var vizULineas;
var vizUBarras;
var vizeotLineas;
var vizeotBarras ;
var vizOds;
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
                  
                 
                if(event.name=='SelvarElgC' || event.name=='ciudadOpCru'){
                   
                  console.log(vizLineObjCruces);
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
                
                if(event.name=='SelSegVar' || event.name=='ciudadOpCru'){
                   console.log(vizLineObjCrucesDS);
                   console.log(vizLineSubjCrucesDS);
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
                    
                       var tipo=$("#grafCrucesDSHidden").text();
                       console.log(tipo);
                      if(tipo=='obj'){
                         changeObjCrucesDS();
                      }else{
                        changeSubjCrucesDS();
                      } 
                     
                   }, 3000);
                      
                      
                   
                   
                }
                
                
                
                
                
                //CRUCES POR TEMAS 
                if(event.name=='varPerC'){
                  
                  
                  if(vizLineSubjCrucesTema!=undefined){
                      vizLineSubjCrucesTema.dispose();
                      vizLineSubjCrucesTema = undefined;
                  }
        
                  $("#grafSubC").html('');
                   changeSubjCrucesTema();
                    
                    
                }
                
                if(event.name=='varOfiC'){
                  if(vizLineObjCrucesTema!=undefined){
                      vizLineObjCrucesTema.dispose();
                      vizLineObjCrucesTema = undefined;
                  }
       
                   $("#grafObjC").html('');
        
                    changeObjCrucesTema();
                   
                }
                //FIN CRUCES PR TEMAS
                
                
                //inicio universidades
                if(event.name=='indCCU'){
                  
                    //currentButton = this.id;
         
                    if(vizULineas !=undefined){
                            vizULineas.dispose();
                            vizULineas = undefined;
                    }
                    
                     if(vizUBarras !=undefined){
                            vizUBarras.dispose();
                            vizUBarras = undefined;
                    }
                    
                    $("#vizElgICU").html('');
                  
                    changeUniversidades();
        
                }
                
                if(event.name=='indCCU'){
                  
                   // currentButton = this.id;
         
                    if(vizULineas !=undefined){
                            vizULineas.dispose();
                            vizULineas = undefined;
                    }
                    
                     if(vizUBarras !=undefined){
                            vizUBarras.dispose();
                            vizUBarras = undefined;
                    }
                    
                    $("#vizElgICU").html('');
                  
                    changeUniversidades();
        
                }
                
                if(event.name=='indEOT'){
                  
                   // currentButton = this.id;
         
                    if(vizeotLineas !=undefined){
                            vizeotLineas.dispose();
                            vizeotLineas = undefined;
                    }
                    
                     if(vizeotBarras !=undefined){
                            vizeotBarras.dispose();
                            vizeotBarras = undefined;
                    }
                    
                    $("#vizlinEot").html('');
                  
                    changeEot();
        
                }
                
                //ODS
                 if(event.name=='odsIndicador' ){
                     changeOds();
                  }
                
               
  });
              

$(document).on('click', '.buttonStyleGraph', function () {
       //Shiny.onInputChange('lastGraph',this.id);
       console.log('chanheeee');
      changeSUbj();
      
   });

     $(document).on('click', '.BUgrafIEOT', function () {
       //Shiny.onInputChange('lastGraph',this.id);
       
                currentButton = this.id;
         
                    if(vizeotLineas !=undefined){
                            vizeotLineas.dispose();
                            vizeotLineas = undefined;
                    }
                    
                     if(vizeotBarras !=undefined){
                            vizeotBarras.dispose();
                            vizeotBarras = undefined;
                    }
                    
                    $("#vizlinEot").html('');
                  
                    changeEot();
      
   });





  
$(document).on('click', '.BuGraphIcu', function () {
        //Shiny.onInputChange('lastGraphICU',this.id);
        
         currentButton = this.id;
         
          if(vizULineas !=undefined){
                vizULineas.dispose();
                vizULineas = undefined;
        }
        
         if(vizUBarras !=undefined){
                vizUBarras.dispose();
                vizUBarras = undefined;
        }
        
        $("#vizElgICU").html('');
      
        changeUniversidades();
        
        //vizElgICU
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
        
        console.log(vizLineObj);
        if(vizLineObj !=undefined)
        {
           console.log(vizLineObj);
          
           vizLineObj.dispose();
            
           vizLineObj = undefined;
        }
        if(vizStackObj !=undefined){
          console.log(vizStackObj);
                vizStackObj.dispose();
                vizStackObj = undefined;
        }
        
         if(vizTreemapObj !=undefined){
                vizTreemapObj.dispose();
                vizTreemapObj = undefined;
        }
        
         /*if(vizmapaObj !=undefined){
                vizmapaObj.dispose();
              vizmapaObj = undefined;
        }*/
        
        
          $("#VizObj").html('');
        
        if(currentButton!='mapa'){
          // $("#vizMapObj").css('display', 'none');
          changeObj();
        }else{
        //  $("#vizMapObj").css('display', 'block');
        }
          
        
   });
   
   
   
$(document).on('click', '.buttonStyleGraphObjCiud', function () {
        
         currentButton = this.id;
       
        //if(currentButton=='linea'){
        
        
            console.log(vizLineObjC);
            if(vizLineObjC !=undefined)
            {
             vizLineObjC.dispose();
             vizLineObjC = undefined;
             console.log(vizLineObjC);
            }
            if(vizStackObjC !=undefined){
                    vizStackObjC.dispose();
                    vizStackObjC = undefined;
            }
            
            
             $("#VizObjCif").html('');
          
            changeObjC();
        /*}else{
          
          if(vizLineObjC !=undefined)
            {
             vizLineObjC.dispose();
             vizLineObjC = undefined;
             console.log(vizLineObjC);
             
             
            }
           //$("#VizObjCif").html('');
           
           console.log(currentButton);
           Shiny.onInputChange('lastGraphObjC',currentButton);
        }*/
        
        
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

                          Name:$("#varCiudadSubjSel").val(),
                          
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
                        Name:$("#varCiudadSubjSel").val(),
                         
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
                             Name:$("#varCiudadSubjSel").val(),
                          

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
    
    console.log(vizLineObj);
  
      if (vizLineObj == null || vizLineObj==undefined) {
        console.log('entró');
         var containerDiv = document.getElementById("VizObj"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja1?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
                            Name:$("#VariablesObjtivos").val(),
                             onFirstInteractive: function () {
                               console.log('ya lo hizo');
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
                         Name:$("#VariablesObjtivos").val(),
                             onFirstInteractive: function () {
                                 changeObj();
                                                        
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
                             Name:$("#VariablesObjtivos").val(),
                             onFirstInteractive: function () {
                                 changeObj();
                                                        
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
    
    
    
    
    /*if(currentButton=='mapa'){
      
   
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
    }*/
  
}






function changeObjC(){
  
  console.log(currentButton);
  
  if(currentButton=='linea'){
    
    
       
  
  console.log(vizLineObjC);
      if (vizLineObjC == null || vizLineObjC==undefined) {
         var containerDiv = document.getElementById("VizObjCif"),
                          url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja5?:embed=y&:display_count=yes&publish=yes",
                          options = {
                              hideTabs: true,
                              name:$("#varObjCiudadE").val(),
                             
                              //width: window.innerWidth,
                             // height: window.innerHeight,
                             onFirstInteractive: function () {
                                 changeObjC();
                                                        
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
                             // width: window.innerWidth,
                              //height: window.innerHeight,
  
  
                            Name:$("#varObjCiudadE").val(),
                            
                             onFirstInteractive: function () {
                                 changeObjC();
                                                        
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
  
 console.log('changeObjCruces');
 
 
    
    if (vizLineObjCruces == null || vizLineObjCruces==undefined) {
       var containerDiv = document.getElementById("grafCrucesD"),
                        url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja7?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                            
                            height:'500px',
                              width:'100%',
                              
                           
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
  
 
 
 console.log(vizLineSubjCruces);
    
    if (vizLineSubjCruces == null || vizLineSubjCruces == undefined) {
      console.log('haciendoooo');
       var containerDiv = document.getElementById("grafCrucesD"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja5?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                            
                            height:'500px',
                              width:'100%',
                            
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
  
 
 
 
    
    if (vizLineObjCrucesDS == null || vizLineObjCrucesDS==undefined) {
       var containerDiv = document.getElementById("grafCrucesDS"),
                        url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja7?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                             height:'500px',
                               width:'100%',
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
  
 
 
 
 console.log(vizLineSubjCrucesDS);
    
    if (vizLineSubjCrucesDS == null || vizLineSubjCrucesDS==undefined) {
       var containerDiv = document.getElementById("grafCrucesDS"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja5?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                           
                            height:'500px',
                            width:'100%',

                            
                            onFirstInteractive: function () {

                                  changeSubjCrucesDS();
                            }
                        };
                    vizLineSubjCrucesDS = new tableau.Viz(containerDiv, url, options);
    }else{
       
 
 console.log('actuali');
 
         var sheet = vizLineSubjCrucesDS.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#SelSegVar").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
            var fieldname = "City";
            var value = $("#ciudadOpCru").val();
            
            console.log(value);
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             
           
    }
    
  
   
    
    
  
}




//cruces por tema



function changeObjCrucesTema(){
  
 
 
 
    
    if (vizLineObjCrucesTema == null || vizLineObjCrucesTema==undefined) {
       var containerDiv = document.getElementById("grafObjC"),
                        url = "https://public.tableau.com/views/Ciudatosobjetivos/Hoja7?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                          
                           

                            
                            onFirstInteractive: function () {

                                  changeObjCrucesTema();
                            }
                        };
                    vizLineObjCrucesTema = new tableau.Viz(containerDiv, url, options);
    }else{
         var sheet = vizLineObjCrucesTema.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#varOfiC").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             var fieldname = "City";
            var value = $("#cidCruc").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             
           
    }
    
  
   
    
    
  
}


function changeSubjCrucesTema(){
  
 
 
 
    
    if (vizLineSubjCrucesTema == null || vizLineSubjCrucesTema==undefined) {
       var containerDiv = document.getElementById("grafSubC"),
                        url = "https://public.tableau.com/views/CiudatosGraficos/Hoja5?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                            
                            

                            
                            onFirstInteractive: function () {

                                  changeSubjCrucesTema();
                            }
                        };
                    vizLineSubjCrucesTema = new tableau.Viz(containerDiv, url, options);
    }else{
         var sheet = vizLineSubjCrucesTema.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#varPerC").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
            var fieldname = "City";
            var value = $("#cidCruc").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
             
           
    }
    
  
   
    
    
  
}






//fin cruces por tema

//inicio EOT
function changeEot(){
  
  
  currentButton = 'linea';
  
  if(currentButton=='linea'){
    
    
    if (vizeotLineas == null || vizeotLineas==undefined) {
       var containerDiv = document.getElementById("vizlinEot"),
                        url = "https://public.tableau.com/views/ciudatoseot/Hoja1?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                            Name:$("#indEOT").val(),

                            onFirstInteractive: function () {
                               changeEot();
                                                      
                            }
                        };
                    vizeotLineas = new tableau.Viz(containerDiv, url, options);
    }else{
        
         var sheet = vizeotLineas.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#indEOT").val();
         
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
            
           
    }
  }
  
  
    
    
    
    if(currentButton=='barras'){
    
    if (vizeotBarras == null || vizeotBarras==undefined) {
       var containerDiv = document.getElementById("vizlinEot"),
                        url = "https://public.tableau.com/views/ciudatoseot/Hoja2?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                            Name:$("#indEOT").val(),

                           onFirstInteractive: function () {
                               changeEot();
                                                      
                            }
                        };
                    vizeotBarras = new tableau.Viz(containerDiv, url, options);
    }else{
      
         var sheet = vizeotBarras.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#indEOT").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
           
     }
    }
    
    
    
    
    
  
}
//FIN EOT
//INICIO UNIVERDIDADES



function changeUniversidades(){
  
  
  
  if(currentButton=='linea'){
    
    
    if (vizULineas == null || vizULineas==undefined) {
       var containerDiv = document.getElementById("vizElgICU"),
                        url = "https://public.tableau.com/views/Ciudatos-universidaes/Hoja1?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                            Name:$("#indCCU").val(),

                            onFirstInteractive: function () {
                               changeUniversidades();
                                                      
                            }
                        };
                    vizULineas = new tableau.Viz(containerDiv, url, options);
    }else{
        
         var sheet = vizULineas.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#indCCU").val();
         
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
            
           
    }
  }
  
  
    
    
    
    if(currentButton=='barras'){
      
      console.log('son barras');
    console.log(vizUBarras);
    if (vizUBarras == null || vizUBarras==undefined) {
       var containerDiv = document.getElementById("vizElgICU"),
                        url = "https://public.tableau.com/views/Ciudatos-universidaes/Hoja2?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                            Name:$("#indCCU").val(),

                           onFirstInteractive: function () {
                               changeUniversidades();
                                                      
                            }
                        };
                    vizUBarras = new tableau.Viz(containerDiv, url, options);
    }else{
      
         var sheet = vizUBarras.getWorkbook().getActiveSheet();
            var fieldname = "Name";
            var value = $("#indCCU").val();
           
            if (value !== "") {
                sheet.applyFilterAsync(fieldname, value, tableau.FilterUpdateType.REPLACE);
            }
           
     }
    }
    
    
    
    
    
  
}


//ODS



function changeOds(){
  
  
    if (vizOds == null) {
       var containerDiv = document.getElementById("vizOds"),
                        url = "https://public.tableau.com/views/Odsciudatos/Hoja1?:embed=y&:display_count=yes&publish=yes",
                        options = {
                            hideTabs: true,
                            Indicator:$("#odsIndicador").val(),

                           
                            onFirstInteractive: function () {

                                  changeOds();
                            }
                        };
                    vizOds = new tableau.Viz(containerDiv, url, options);
    }else{
         var sheet = vizOds.getWorkbook().getActiveSheet();
            var fieldname = "Indicator";
            var value = $("#odsIndicador").val();
           
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