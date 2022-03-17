<%@page import="dbutils.Utils"%>
<%@page import="java.io.InputStream"%>
<%@page import="dbutils.Utils.*"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.HashMap"%>
<%@page import="dbutils.PDO"%>
<%@page import="dbutils.DBConnect"%>
<%@page import="java.sql.*" %>
<%@page import="java.util.Enumeration" %>


<%! 
   PDO db;
%>
<% 
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    String modifier = (String) request.getParameter("modifier");
    db = (PDO)session.getAttribute("pdo");
    HashMap<String, Object> not = null;
    if(modifier != null){
        db.prepare("SELECT n.*, c.niveau, c.session, c.filiere  FROM notes n, cours c WHERE id_note = :pId_note and n.codeCours = c.codeCours");
        db.params("pId_note", modifier);
        if(db.execute()){
            if(db.hasNext()){
                not = db.fetch();
            }
        }
    }
%>
<%
    ArrayList<String[]> myList = Utils.selectEtudiant();
    ArrayList<String> listF = Utils.filiere();
    ArrayList<String[]> listC = Utils.selectCours();
    ArrayList<String[]> listP = Utils.selectProfesseur();
    ArrayList<HashMap> listHoraire = Utils.getHoraires();
    int i =0;
%>
<script>
    var dataset = {
        cours : {},
        professeur: {},
        horaires: {}
    };
    
    <% 
    int k = 0;
    for(String[] crs : listC){ %>
        dataset.cours[<%= k %>] = {
            "id" : "<%= crs[0] %>",
            "nom" : "<%= crs[1] %>",
            "coefficient" : <%= crs[2] %>,
            "niveau" : "<%= crs[3] %>",
            "filiere" : "<%= crs[5] %>",
            "session" : <%= crs[4] %>,
            "titulaire" : "<%= crs[6] %>",
            "suppleant" : <%= crs[7] == null ? null : "\""+crs[7]+"\"" %>
        }
    <% 
        k++;
    } 
        k = 0;
    %>
    <% 
    for(String[] prof : listP){ %>
        dataset.professeur[<%= k %>] = {
            "id" : "<%= prof[0] %>",
            "nom" : "<%= prof[1] %>",
            "filiere" : "<%= prof[2] %>"
        }
    <% 
        k++;
    } 
    k = 0;
    %>
    <% 
    for(HashMap hr : listHoraire){ %>
        dataset.horaires[<%= k %>] = {
            "id" : "<%= hr.get("id") %>",
            "nom" : "<%= hr.get("nomCours") %>",
            "filiere" : "<%= hr.get("filiere") %>",
            "niveau" : "<%= hr.get("niveau") %>",
            "session" : "<%= hr.get("session") %>",
            "titulaire" : "<%= hr.get("titulaire") %>",
            "suppleant" : "<%= hr.get("suppleant") %>",
            "jour" : "<%= hr.get("jour") %>",
            "heure_debut" : "<%= hr.get("heure_debut") %>",
            "heure_fin" : "<%= hr.get("heure_fin") %>",
            "type" : "<%= hr.get("type") %>"
        }
    <% 
        k++;
    } 
    k = 0;
    %>
</script>
<div class="popup_entry <%= not !=null ? "active" : "" %>">

    <div class="entry">
        <div class="popup_head"> 
            <h3> Programmer une séance</h3>
        </div>
        <div class="popup_body">
            <form action="./panel?res=horaire" method="POST" class="form_entry">
                <input type="hidden" name="seanceId" value=" <%= not == null ? "" : not.get("id_note")%>" >
                <div class="input">
                    <select name="filiere" <%= not == null ? "" : "disabled" %>>
                        <option value="">Choisissez la filiere</option>
                        <%for(String filiere : listF) {%>
                        <option value="<%= filiere %>" <%= not == null || !not.get("filiere").toString().equals(filiere) ? "" : "selected" %>> <%= filiere %> </option>
                       <%
                           i++;
                       }%>
                    </select>
                </div>
                <div class="input">
                    <select name="niveau" <%= not == null ? "" : "disabled" %>>
                        <option value="">Choisissez le niveau</option>
                        <% if(not != null){ 
                            for(String niveau : Utils.getNiveau(not.get("filiere").toString())){
                        %>
                        <option value="<%= niveau %>" <%= not == null || !not.get("niveau").toString().equals(niveau) ? "" : "selected" %> ><%= niveau %></option>
                        <%  }
                           }
                        %>
                    </select>
                </div>
                <div class="input">
                    <select name="session" <%= not == null ? "" : "disabled" %> >
                        <option value="">Selectionnez la session</option>
                        <option value="1" <%= not == null || !not.get("session").toString().equals("1") ? "" : "selected" %> >Session 1</option>
                        <option value="2" <%= not == null || !not.get("session").toString().equals("2") ? "" : "selected" %> >Session 2</option>
                    </select>
                </div>
                <div class="input">
                    <select name="cours" <%= not == null ? "" : "disabled" %>>
                        <option value="">Selectionnez le cours</option>
                        <% if(not != null){ 
                            for(String[] crs : Utils.selectCours(not.get("filiere").toString(), not.get("niveau").toString())){
                        %>
                        <option value="<%= crs[0] %>" <%= not == null || !not.get("codeCours").toString().equals(crs[0]) ? "" : "selected" %> ><%= crs[1] %></option>
                        <%  }
                           }
                        %>
                    </select>
                </div>
                <div class="input">
                    <select name="jour" <%= not == null ? "" : "disabled" %>>
                        <option value="">Sélectionnez le jour</option>
                        <% for(String jour : Utils.getJours()){
                        %>
                        <option value="<%= jour %>" <%= not == null || !not.get("codeCours").toString().equals(jour) ? "" : "selected" %> ><%= jour %></option>
                        <% 
                           }
                        %>
                    </select>
                </div>
                <div class="input">
                    <select name="type" <%= not == null ? "" : "disabled" %>>
                        <option value="">Sélectionnez le type du cours</option>
                        <option value="cours magistral">Cours magistral</option>
                        <option value="tp">TP</option>
                    </select>
                </div>
                <div class="input">
                    <input placeholder="" type="time" name="heure_debut" value="<%= not == null  ? "" : not.get("noteSur100") %>">
                </div>
                <div class="input">
                    <input type="time" name="heure_fin" value="<%= not == null  ? "" : not.get("noteSur100") %>">
                </div>
            </form>
        </div>
        <div class="button_input">
            <button type="submit" value="submit" name="submit" id="submit" style="cursor:pointer;">Ajouter</button>
            <button type="reset" value="clear" name="clear" id="quit" class="quit" style="cursor:pointer;">Quiter</button>
        </div>              
    </div>
</div>

<div class="main-content">
    
    <div class="head">
       <div class="view">
           <span class=" las la-tasks"></span>
           <h2 class=" title_view">Horaire</h2>
       </div>
       <div class="AcadY">
           <span class="iconY las  la-calendar-check"></span>
           <span class="ActualY">2020-2021</span>
       </div>
    </div>
    <%
        db = (PDO) session.getAttribute("pdo");
        String id = (String)request.getParameter("seanceId");
        String idcours = (String) request.getParameter("cours");
        String jour = (String) request.getParameter("jour");
        String debut = (String) request.getParameter("heure_debut");
        String fin = (String) request.getParameter("heure_fin");
        String type = (String) request.getParameter("type");
        String idSeance = (String) request.getParameter("trash");
        
        System.out.println("idN: "+id);
        System.out.println("Trash: "+idSeance);
        System.out.println("cours: "+idcours);
        System.out.println("Jour: "+jour);
        System.out.println("Debut: "+debut);
        System.out.println("Fin: "+fin);
        System.out.println("type: "+type);
        System.out.println("not: "+not);
        
        if(idSeance !=null){
            db.prepare("DELETE FROM horaire WHERE id =:id");
            db.params("id",idSeance);
           
             if(db.execute()){
            %>
            <div class="boxAlert">Suppression reussi!</div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
            }
        }
    
    if(idcours !=null && jour !=null && debut !=null && fin != null && type != null){
        if(id ==null || id.length() ==0 ){
            db.prepare("INSERT INTO horaire (idCours,jour,heure_debut,heure_fin,type) VALUES(:cours,:jour,:debut,:fin,:type)");
        }else{
            db.prepare("UPDATE notes SET idCours=:cours, jour=:jour, heure_debut=:debut, heure_fin=:fin, type=:type WHERE id =:id  ");
        }

        db.params("jour", jour);
        db.params("cours", idcours);
        db.params("debut", debut);
        db.params("fin", fin);
        db.params("type", type);
        db.params("id", id);
        
         if(db.execute()){
            %>
            <div class="boxAlert"><%= id.length() > 0 ? "Modification reussi! " : "Enregistrement reussi!" %></div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
        }
        
    }
    %>
    <div class="lastBolock">
        <div class="see" id="notes">
            <div class="button_head">
                <button class="print" onClick="printForm('horaire')">
                    <span class="print_icon las  la-print"></span>
                    <span class="print_span"></span> 
                </button>
                <button class="print">
                    <span class="print_icon las  la-plus-square"></span>
                    <span class="add_span"></span> 
                </button>
            </div>
            <div class="rang">
                <form action="./panel?res=professeur" class="rang_entry" method="POST">
                    <div class="rang_input">
                        <select name="filiere">
                            <option value=''>Choisissez la filiere</option>
                            <%for(String filiere : listF) {%>
                           <option value="<%= filiere %>"> <%= filiere %> </option>
                           <%
                               i++;
                              }
                           %>
                        </select>
                    </div>
                    <div class="rang_input">
                        <select name="niveau">
                            <option value=''>Choisissez le niveau</option>
                        </select>
                    </div>
                    <div class="rang_input">
                        <select name="session">
                            <option value="">Selectioner la session</option>
                            <option value="1">Session 1</option>
                            <option value="2">Session 2</option>
                        </select>
                    </div>
                </form>
            </div>
        <div class="horaire-view" id="horaire">
            <% for(String day : Utils.getJours()){ %>
            <div class="day-column" for="<%= day %>">
                <div class="en-tete"><%= day %></div>
                <div class="cours">
                </div>
            </div>
            <% } %>
        </div>                  
    </div>
</div>
 <script>
     var base = 12 * 60;
     function tempsEnMinute(heure){
         var t = heure.split(':');
         return (parseInt(t[0]) - 7) * 60 + parseInt(t[1]);
     }
     function positionRelative(debut, fin){
         var debut = tempsEnMinute(debut);
         return{
             top: debut / base * 100,
             height: (tempsEnMinute(fin) - debut) / base * 100
         }
     }
     $('.rang').on('change', '[name]', function(){
         var filiere = $('.rang [name="filiere"]').val(),
             niveau = $('.rang [name="niveau"]').val(),
             session = $('.rang [name="session"]').val(),
             pos;
         console.log({filiere,niveau,session,horaire: dataset.horaires})
         $('.horaire-view .day-column .cours').html('');
         for(var i in dataset.horaires){
             if(dataset.horaires[i].filiere == filiere && dataset.horaires[i].niveau == niveau && dataset.horaires[i].session == session){
                pos = positionRelative(dataset.horaires[i].heure_debut, dataset.horaires[i].heure_fin);
                console.log('[Pos]', pos,dataset.horaires[i]);
                $('.horaire-view .day-column[for="'+dataset.horaires[i].jour+'"] .cours').append(
                    '<div class="case" style="top: '+pos.top+'%; height: '+pos.height+'%">'+
                        '<div class="seance">'+
                            '<span class="nom">'+dataset.horaires[i].nom+'</span>'+
                            '<span class="heure">'+dataset.horaires[i].heure_debut+' - '+dataset.horaires[i].heure_fin+'</span>'+
                            '<span class="prof">'+(dataset.horaires[i].type == 'TP' ? dataset.horaires[i].suppleant == 'null' ? 'A préciser' : dataset.horaires[i].suppleant : dataset.horaires[i].titulaire)+'</span>'+
                        '</div>'+
                    '</div>'
                )
             }
         }
     })
</script>
<style>
/*    #notes{
        display: block;
    }*/
    #bultin{
        display: none;
    }
    #palmares{
        display: none;
    }
    .rang_input{
      padding: 10px;
      color: #ffffff;
      font-size: 14px;
    }
    .rang{
        width: 100%;
    }
    .rang form{
        display: flex;
    }
   .rang_input select{ 
        background-color: #ffffff;
        height: 30px;
        width: 200px;
        border: 0;
        outline: none;
        padding: 0 8px;
        border-radius: 10px;
   }
    .print{
        width: 50px;
        display: inline-flex;
        background-color: #f09103;
        margin: 0.3em .5em .4em 0;
        border: none;
        height: 40px;
        justify-content: left;
        border-radius: 5px;
        overflow: hidden;
        box-shadow: 0 10px 10px rgba(0, 0, 0, 0.1);
        transition-property: width;
        transition-duration: .2s;
    }
    .print:hover{
        width: 250px;
        display: inline-flex;
        background-color: var(--main);
        margin: 0.3em .5em .4em 0;
        border: none;
        height: 40px;
        align-items: center;
        border-radius: 5px;
        overflow: hidden;
        box-shadow: 0 10px 10px rgba(0, 0, 0, 0.1);

    }

    .print_span::before{
        content: "";
        font-size: 1.5em;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #ffffff;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    } 
    .button_head .add_span::before{
        content: "";
        font-size: 1.5em;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #ffffff;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    }
    .button_head .add_span::after{
        content: "Ajouter";
        font-size: 1.5em;
        font-weight: 600;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #ffffff;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    }
   
  
   .print_span::after{
        content: "Imprimer";
        text-transform: uppercase;
        font-size: 1.5em;
        font-weight: 600;
        padding: 0.2em 1em ;
        color:  #131D28;
        height: 40px;
        color: #efefef;
        width: 90%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    } 
   
    .print_icon{
        border: none;
        background: #f09103;
        line-height: 40px;
        height: 40px;
        font-size: 2em;
        padding: 0 11px;
        color: #efefef;
    }
   /* entry */
   .avatar{
       height: 100px;
       width: 100px;
       border: 1px solid #000;
       border-radius: 50px; 
       display: flex;
       align-items: center;
       justify-content: center;
       font-size: 2em;
       color: #131D28;
       background-size: auto 100%;
       background-position: center;
       background-repeat: no-repeat;
    }
    .file{
        display: none;
    }
     .popup_entry{
        top: 0;
        bottom: 0;
        left: 0;
        right: 0;
        position: absolute;
        z-index: -1;
        opacity: 0;
        transition-duration: .2s;
        transition-property: z-index, opacity;
        display: flex;
        align-items: center;
        justify-content: center;
        border-radius: 5px;
    }

    .popup_entry.active{
        z-index: 3;
        opacity: 1;
    }
    .popup_head{
        background: #fff;
        height: 60px;
        width: 100%;
        display: inline-block;
        text-transform: uppercase;

    }
    .popup_head h3{
        align-items: center;
        padding: 10px 30px;
        margin: .1em 8.5em;
        color: #131D28;
        font-size: 17px;
        font-weight: 600;
    }
    .popup_body{
        background: #ffffff;
        display: inline-block;
        overflow: hidden;
        overflow-y: auto;
        padding: .5em 3em;
    }
    .entry{
        display: flex;
        flex-direction: column;
        background: #ffffff;
        height: 90vh;
        overflow: hidden;
        z-index: 3;
    }

    .entry .input {
        width: 49%;
        border: 0;
        margin: .2em 0;
        outline: none;
        padding: .4em;
        padding-bottom: 0;
        border-radius: 1em;
        display: inline-flex;
        flex-direction: column;
    }

    .entry input:focus {
        border-bottom-color: #ffa600c5;
    }
    .entry label{
        width: 100%;
        display: inline-block;
        color: #161616;
        font-size: .8em;
    }
    .labels{
        font-size: 14px;
    }
    .entry input, select, textarea{
        padding: .5em;
        border: 0;
        background-color: inherit;
        border-bottom: 1px solid orange;
    }
    textarea{
        margin: 5px;
        resize: none;
        outline: none;
    }
    .textarea_style{
        margin: 5px;
        width: auto;
        height: auto;
        font-size: 14px;

    }
    textarea::-webkit-scrollbar{
        width: 3px;
    }
    textarea::-webkit-scrollbar-track{
        -webkit-box-shadow:inset 0 0 10px #bddae0 ;
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.03);
    }
    textarea::-webkit-scrollbar-thumb{
        background-color: #0bbff9;
    }
    .entry button{
        margin: .6em;
        outline: none;
        width: 30%;
        color:#131D28;
        border: none;
        border-radius: 5px;
        height: 30px;
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.04);
        font-weight: 600;
    }
   
    .button_input #submit, #quit{
        background: #9f9f9f;
    }
    .button_input{
        margin-left: 9.5em;
    }
    .trash{
        font-size: 1.5em;
        color: #ff3c00;
    }
    .trash:hover{
        background: rgb(255, 197, 189);
        padding: 2px;
        justify-content: center;
        border: solid .9px #ff3c00;
        width: 30px;
        height:30px;
        border-radius: 50%;
    }
    .pen{
        color: #0084ff;
        font-size: 1.5em;
    }
    .pen:hover{
        background: #e1eeffcb;
        padding: 2px;
        justify-content: center;
        border: solid .9px #0084ff;
        width: 30px;
        height:30px;
        border-radius: 50%;
    }

    .head{
        display: flex;
        justify-content: space-between;
        padding: 2rem 1rem;
        align-items: center;
    }
    .AcadY{
        font-size: 2rem;
        color: #efefef;
        align-items: center;
        display: flex;
    }
    .iconY{
        font-size: 1.5em;
    }
    .button__head {
        display: inline-flex;
        border-radius: 5px;
    }
    .button__head div{
        display: inline-flex;
        align-items: center;
        justify-content: center;
        padding: .5em 2em;
        font-weight: 600;
    }
    .btn_radio{
        display: inline-flex;
    }
    .head{
        display: flex;
        justify-content: space-between;
        padding: 2rem 1rem;
        align-items: center;
    }
    .view{
        display: flex;
        color: #efefef;
        align-items: center;
    }
    .view {
        font-size: 4em;
    }
    .title_view{
        font-weight: 500;
        font-size: 2.3rem;
    }
   
    .lastBolock{
        display: inline-block;
        width: 100%;
    }
    .see{
        display: flex;
        flex-direction: column;
        width: 100%;
        margin-top: 2em;
        height: auto;
        overflow: hidden;
        overflow-x: auto;

    }
    .colums{ 
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        color: #131D28;
        background: #efefef;
        font-weight: bold;
        justify-content: space-between;
        font-size: 1em;
        padding: 1em;
    }

    .allrows{
        display: inline-block;
        height: 60vh;
        width: 100%;
        overflow-y: auto;
    }
    .rows{
        width: 100%;
        display: grid;
        grid-template-columns: repeat(7, 1fr);
        justify-content: space-between;
        align-items: center;
        color: #efefef;
        font-size: 1em;
        padding: 1em;
        border: solid .1em #efefef;
        position: relative
    }
    .rows .row-info{
        position: absolute;
        top: 100%;
        left: 0;
        width: 100%;
        height: 350px;
        background-color: #efefef;
        z-index: 2;
        display: none;
    }

    .row-info .span_info{
        color: #131D28;
        font-size: 18px;
        font-weight: 600;
    }
    .rows:hover{
        background: #efefef;
        color: #131D28;
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.03);
        border: solid 3px #131D28;
    }
    .rows.active .row-info{
        display: grid;
        color: #131D28;
        grid-template-columns: 20% 80%;
        justify-content: space-between;
        border: solid 1.5px #131D28;
        padding: 20px;
        overflow-y: auto;
    }
    .row-info .list_info{
        display: grid;
        grid-template-columns: repeat(3, 1fr) ;
        justify-content: space-between;
        padding: 20px;
        border: none;
    }
    .rows:focus{
        background: #efefef;
        color: #131D28;
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(0,0,0,0.03);
        border: solid 3px #131D28;
    }
    .rows:focus .row-info{
        display: inline-block;
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(255, 192, 192, 0.3);
        border: solid 1.5px #131D28;
    }

    .rows:focus{
        -moz-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03) ;
        -webkit-box-shadow:0px 0px 5px 1px rgba(0,0,0,0.03);
        box-shadow: 0px 0px 5px 1px rgba(255, 192, 192, 0.03);
        border: solid 1.5px #131D28;
    }
    .profil_img{
        height: 45px;
        width: 45px;
        background-size: cover;
        background-repeat: no-repeat;
        border-radius: 50%;
        border: 3px solid #efefef;
        position: relative;   
        background-size: auto 100%;
        background-repeat: no-repeat;
        background-position: center; 
    }
    .Iprofil_img{
        height: 150px;
        width: 150px;
        background-size: auto 100%;
        background-repeat: no-repeat;
        background-position: center;
        top: 0;
        border: 4px solid #efefef;
        border-radius: 50%;
    }

</style>
<script src="./js/note.js"></script>