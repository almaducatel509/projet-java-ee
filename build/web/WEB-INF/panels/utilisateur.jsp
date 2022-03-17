<%@page import="dbutils.Utils"%>
<%@page import="java.util.HashMap"%>
<%@page import="dbutils.PDO"%>
<%@page import="dbutils.DBConnect"%>

<%! 
    PDO db;
%>

<% 
    String modifier = (String) request.getParameter("modifier");
    db = (PDO)session.getAttribute("pdo");
    HashMap<String, Object> uti = null;
 
    if(modifier != null){
        db.prepare("SELECT * FROM utilisateur WHERE idUtilisateur = :pIdUtilisateur");
        db.params("pIdUtilisateur", modifier );
        if(db.execute()){
            if(db.hasNext()){
                uti = db.fetch();
            }
        }
    }
%>
<div class="popup_entry  <%= uti != null ? "active" : "" %>">
    <div class="entry">
        <div class="popup_head">
            <h3>Enregistrer un utilisateur</h3>
        </div>
        <div class="popup_body">  
         <form action="./panel?res=utilisateur" method="post" class="form_entry">
            <input type="hidden" name="utiId" value="<%= uti == null ? "" : uti.get("idUtilisateur") %>">
            <div class="avatar">
                <input class="file" type="file" value="" />
                <i class="las la-camera"></i>
            </div> 
            <input class="avatar_input" type="hidden" name="avatar" value="" />
            
            <div class="input">
                <label for="lastname" class="labels">Entrez le nom</label>
                <input type="text" name="lastname" placeholder="Nom" value="<%= uti == null ? "" : uti.get("nomUser") %>">
            </div>
            <div class="input">
                <label for="firstname" class="labels">Entrez le prenom</label>
                <input type="text" name="firstname" placeholder="Prenom" value="<%= uti == null ? "" : uti.get("prenomUser") %>">
            </div>
            <div class="input">
                <label for="pseudo" class="labels">Entrez le pseudo</label>
                <input type="text" name="pseudo" placeholder="Pseudo" value="<%= uti == null ? "" : uti.get("pseudo") %>">
            </div>
            <div class="input">
                <label for="poste" class="labels">Choisissez le poste</label>
                <select name="poste" required>
                    <option value="">Poste</option>
                     <%
                     for(String poste : Utils.Poste()) {
                     %>
                     <option value="<%= poste%>" <%= uti == null || !uti.get("poste").toString().equals(poste) ? "" : "selected"  %> > <%= poste%> </option>
                     <%
                     }
                     %>
                </select>
            </div>
            <div class="privileges">
                <label for="pass" class="labels">Choisissez les privilèges</label>
                <input type="hidden" name="privileges">
                <% for(String privilege : Utils.allPrivileges()){ %>
                    <div class="check">
                        <input type="checkbox" <%= uti == null || !uti.get("privilege").toString().contains(privilege) ? "" : "checked"  %> value="<%= privilege %>" id="<%= privilege %>">
                        <label for="<%= privilege %>"><%= privilege %></label>
                    </div>
                <% } %>
            </div>
            <div class="input">
                <label for="pass" class="labels">Entrez le mot de passe</label>
                <input type="password" name="pass" placeholder="Mot de passe" value="<%= uti == null ? "" : uti.get("pass") %>">
            </div>
            <div class="input">
                <label for="passconfirm" class="labels">Confirmez le mot de passe</label>
                <input type="password" name="passconfirm" placeholder="Mot de passe" value="<%= uti == null ? "" : uti.get("pass") %>">
            </div>
           
        </form>
        </div>
        <div class="button_input">
            <button type="submit" value="Submit" name="submit" id="submit">Ajouter</button>
            <button type="reset" value="Clear" name="clear" id="quit" class="quit">Quiter</button>
        </div>
        
    </div>
</div>
 
<% 
    db = (PDO)session.getAttribute("pdo");
    String idU = (String)request.getParameter("utiId");
    String nom =(String)request.getParameter("lastname");
    String codeUtilisateur =(String)request.getParameter("codeUtilisateur");
    String prenom = (String)request.getParameter("firstname");
    String pseudo = (String)request.getParameter("pseudo");
    String poste = (String)request.getParameter("poste");
    String pass = (String)request.getParameter("pass");
    String avatar = (String) request.getParameter("avatar");
    String privileges = (String) request.getParameter("privileges");
    String idUtilisateur = (String) request.getParameter("trash");
       
    System.out.println("nom: "+nom);
    System.out.println("prenom: "+prenom);
    System.out.println("pseudo: "+pseudo);
    System.out.println("poste: "+poste);
    System.out.println("pass: "+pass);
    System.out.println("avatar "+avatar);
    System.out.println("ID "+idU);
    System.out.println("Privileges "+privileges);
//delete       
     if(idUtilisateur !=null){
        db.prepare("DELETE FROM utilisateur WHERE idUtilisateur =:pIdUtilisateur");
        db.params("pIdUtilisateur", idUtilisateur);
        
        if(db.execute()){
            %>
            <div class="boxAlert">Supression reussi!</div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
        }
    }
//fin delete
 
//add sql vs jsp
    if(nom != null && prenom !=null && poste !=null && pass !=null ){

        if(avatar != null){
            avatar = Utils.uploadFile(avatar, this.getServletContext().getRealPath("/")+"media/", null);
        }
        if(idU == null || idU.length() == 0){
             db.prepare("INSERT INTO utilisateur( nomUser, prenomUser, poste, profil, pseudo, pass, privilege)"
                    + " VALUES ( :pNom, :pPrenom, :pPoste, :pProfil,:Ppseudo, :pPass, :privilege)");
        }else{
            db.prepare("Update utilisateur set nomUser=:pNom, prenomUser=prenomUser, poste=:pPoste, pseudo=:Ppseudo, profil=:pProfil, pass=:pPass"
                        + ", privilege=:privilege WHERE idUtilisateur = :pUdp " );
        }

        db.params("pNom", nom);
        db.params("pPrenom", prenom);
        db.params("Ppseudo", pseudo);
        db.params("pPoste", poste);
        db.params("pPass", pass);
        db.params("pProfil", avatar);
        db.params("privilege", privileges);
        db.params("pUdp", idU);
        
        if(db.execute()){
            %>
            <div class="boxAlert">Enregistrement reussi!</div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
        }
    }
%>


<div class="head">
    <div class="view">
        <span class=" las  la-chalkboard-teacher"></span>
        <h2 class=" title_view">Utilisateurs</h2>
    </div>
    <div class="AcadY">
        <span class="iconY las  la-calendar-check"></span>
        <span class="ActualY">2020-2021</span>
    </div>
</div>
<div class="lastBolock">
    <div class="see">
        <div class="button_head">
            <button class="print" onclick="printEorm()">
                <span class="print_icon las  la-print"></span>
                <span class="print_span"></span> 
            </button>
            <button class="print">
                <span class="print_icon las  la-plus-square"></span>
                <span class="add_span"></span> 
            </button>
        </div>
        
            <div class="colums">
                <div class="column">Profil</div>
                <div class="column">Nom</div>
                <div class="column">Prenom</div>
                <div class="column"> Pseudo</div>
                <div class="column"> Poste</div>
                <div class="column"> Statut</div>
                <div class="column">Operation</div>

            </div>
            <div class="allrows">

                <% 
                    db = (PDO)session.getAttribute("pdo");
                    db.prepare("select * from utilisateur");
                    if(db.execute()){
                       HashMap<String, Object> data;
                       while(db.hasNext()){
                           data = db.fetch();
                %>

                    <div class="rows">
                        <div class="row profil_img" style="justify-content: center; background-image: url(./media/<%= data.get("profil") == null ? "Dr_dada.png" : data.get("profil") %>);"></div>
                        <div class="row point nom"><%= data.get("nomUser") %></div>
                        <div class="row point prenom"><%= data.get("prenomUser") %></div>
                        <div class="row"><%= data.get("pseudo") %></div>
                        <div class="row"><%= data.get("poste") %></div>
                        <div class="row"><%= data.get("etat") %></div>
                        <div class="row icons_operation">
                            <form method="post" action="./panel?res=utilisateur">
                                <input type="hidden" name="modifier" value="<%= data.get("idUtilisateur") %>">
                                <button type="submit" class=" pen las  la-pencil-alt"></button>
                            </form>
                            <form method="post" action="./panel?res=utilisateur">
                                <input type="hidden" name="trash" value="<%= data.get("idUtilisateur") %>">
                                <button class=" trash las la-trash-alt" type="submit"></button>
                            </form>
                            <i class="las la-angle-down"></i>
                        </div>
                         <div class="row-info">

                                <div class="row Iprofil_img" style="justify-content: center; background-image: url(./media/<%= data.get("profil") == null ? "Dr_dada.png" : data.get("profil") %>);"></div>
                                <div> 
                                    <div class="list_info">
                                       <div class="info nom">
                                       <span class="span_info">Nom:</span>
                                       <span><%= data.get("nom") %></span>
                                        </div>
                                        <div class="info prenom">
                                            <span class="span_info">Prenom:</span>
                                            <span><%= data.get("prenom") %></span>
                                        </div>

                                        <div class="info poste">
                                            <span class="span_info">Poste:</span>
                                            <span ><%= data.get("poste") %></span>
                                        </div>

                                        <div class="info etat">
                                            <span class="span_info">Etat: </span>
                                            <span><%= data.get("etat") %></span>
                                        </div>
                                        <div class="info memo">
                                            <span class="span_info">Memo: </span>
                                            <span><%= data.get("memo") %></span>
                                        </div>
                                        <div class="etats">
                                            <form method="post">
                                                <div class="etatActive">
                                                    <input type="hidden" name="etat" value="">
                                                    <button type="submit" class="etat__btn">A</button>
                                                </div>
                                                <div class="etatActive">
                                                    <input type="hidden" name="etat" value="">
                                                    <button class="etat__btn" type="submit">I</button>
                                                </div>
                                            </form>
                                        </div>
                                 </div>
                             </div>
                         </div>
                    </div>


                <%      }
                    }

                %>
           </div>
        </div>
    </div>
</div>
<script>
    var privileges = '';
    function collect(){
        privileges = '';
        $('.privileges input').each(function(){
            if(this.checked){
                privileges += (privileges.length ? ',' : '')+$(this).val();
            }
        });
        $('.privileges [type="hidden"]').val(privileges);
    }
    $('.privileges').on('change', 'input', function(){
        collect();
    });
    collect();
</script>
<style>
    
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
        background: #f09103;
        line-height: 40px;
        height: 40px;
        width: 30%;
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
        background:#383838a9;
        display: flex;
        align-items: center;
        justify-content: center;
        place-items: center;
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
        width: 40vw !important;
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
    .entry input, .entry select, .entry textarea{
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
    .opened{
        border-right: solid .1px #131D28;
        background:#efefef;
        color: #131D28;
        border-top-left-radius: 5px;
        border-bottom-left-radius: 5px;

    }
    .closed{
        background:#efefef;
        color:#131D28;
        border-right: solid .1px #131D28;
    }
    .update__infoY{
        background : var(--main);
        color: #131D28;
        height: 45px;
        border-top-right-radius: 5px;
        border-bottom-right-radius: 5px;
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
   
    .closed:hover, .opened:hover{
        background: rgb(252, 248, 208);
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
        position: relative;
    }
    .colums{ 
        display: grid;
        grid-template-columns: repeat(8, 1fr);
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
    .allrows{
       display: inline-block;
       height: 60vh;
       width: 100%;
       overflow-y: auto;
    }
    .rows{
        width: 100%;
        display: grid;
        grid-template-columns: repeat(8, 1fr);
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
    .icons_operation{
        display: flex;
       
    }
    .icons_operation button{
        border: none; background: unset;
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
    .etats form{
        background: #ff3c00;
        display: inline-flex;
    }
    .etatActive{
        margin: 0px;
        
    }
    .etat__btn{
        display: flex;
        border: solid 1.5px #131D28;
        font-size: 1em;
        font-weight: 600;
        padding: 10px;
        align-items: center;
        justify-content: center;
        color:  #131D28;
        height: 40px;
        width: 100%;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    }
   form .etat__btn.active{
        background: var(--main);
        color: #ffffff;
        cursor: pointer;
        transition: all 0.2s cubic-bezier(0.68, 0.55, 0.265, 1.55);
    }

</style>

<script src="./js/popup.js"></script>
<script src="./js/search.js"></script>
<script src="./js/scroll.js"></script>