<%@page import="dbutils.XcelReader"%>
<%@page import="java.io.InputStream"%>
<%@page import="dbutils.Utils"%>
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
    String modifier = (String) request.getParameter("modifier"),
           excel = (String) request.getParameter("excel");
    db = (PDO)session.getAttribute("pdo");
    HashMap<String, Object> etu = null;
    if(modifier != null){
        db.prepare("SELECT * FROM etudiant WHERE idEtudiant = :pIdEtudiant");
        db.params("pIdEtudiant", modifier );
        if(db.execute()){
            if(db.hasNext()){
                etu = db.fetch();
            }
        }
    }
    if(excel != null && excel.length() > 0){
        String[] head =  new String[]{
            "CodeEtudiant", "NomEtudiant", "PrenomEtudiant", "Sexe",
            "Adresse", "Lieu de naissance", "Date de naissance", "Téléphone",
            "Email", "Filière", "Niveau", "NIF/CIN", "Personne de référence",
            "Tél personne référence", "Memo"
        };
        XcelReader xl = new XcelReader(excel,this.getServletContext().getRealPath("/media/")+"\\",head);
        ArrayList<HashMap<String, String>> data = xl.read();
        xl.flush();
        System.out.println(data);
        if(data == null){
            %>
            <div class="boxAlert bad">Erreur d'importation !</div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
        }
        else{
            int saved = 0;
            String _filiere, _niveau, msg = "";
            for(HashMap<String, String> row : data){
                System.out.println(row);
                _filiere = Utils.getTarget(Utils.filiere(), row.get(head[9]));
                if(_filiere != null){
                    _niveau = Utils.getTarget(Utils.getNiveau(_filiere), row.get(head[10]));
                    if(_niveau != null){
                        db.prepare("INSERT INTO etudiant(codeEtudiant,nomEtudiant, prenomEtudiant, sexe, adresse, lieu_naissance, date_naissance, telephone, email, filiere, niveau, nif_cin, personne_ref, tel_ref, memo, annee_academique) "
                                + "VALUES (:pcodeEtudiant, :pNomE, :pEPrenom, :pSexe, :pAdresse, :pLieuNaissance, :pDateNaissance, :pTel, :pEmail, :pFiliere, :pNiveau, :pNifCin, :pPersonneRef, :pTelRef, :pMemo, (select id from annee_academique where etat = 'O' limit 1))");

                        db.params("pcodeEtudiant", row.get(head[0]));
                        db.params("pNomE", row.get(head[1]));
                        db.params("pEPrenom", row.get(head[2]));
                        db.params("pSexe", row.get(head[3]));
                        db.params("pAdresse",row.get(head[4]));
                        db.params("pLieuNaissance", row.get(head[5]));
                        db.params("pDateNaissance", row.get(head[6]));
                        db.params("pTel", row.get(head[7]));
                        db.params("pEmail", row.get(head[8]));
                        db.params("pNiveau", _niveau);
                        db.params("pFiliere", _filiere);
                        db.params("pNifCin", row.get(head[11]));
                        db.params("pPersonneRef", row.get(head[12]));
                        db.params("pTelRef", row.get(head[13]));
                        db.params("pMemo", row.get(head[14]));


                         if(db.execute()){
                              saved++;
                         }
                    }else{
                        msg += "la filiere "+_filiere+" n'a pas <b>"+row.get(head[9])+"</b> comme niveau <br>";
                    }
                }else{
                    msg += "la filiere "+row.get(head[9])+" n'existe pas <br>";
                }
            }
            %>
            <div class="boxAlert <%= saved == 0 ? "bad" : "" %>"><%= saved == 0 ? "Erreur d'execution lors de l'importation" : saved+" enregistrement(s) fait(s) sur "+data.size() %> !
                    <br><%= msg %>
            </div>
            <script>
                setTimeout(function(){
                    document.querySelector(".boxAlert").style.display="none";
                }, 5000);
            </script>
            <%
        }
    }
%>
<div class="popup_entry <%= etu != null ? "active" : "" %>">
    <div class="entry ">
        <div class="popup_head">
            <h3>Enregistrer un(e) etudiant(e)</h3>
        </div>
        <div class="popup_body">
            <form action="./panel?res=etudiant" method="post" class="form_entry">
                <input type="hidden" name="etuId" value="<%= etu == null ? "" : etu.get("idEtudiant") %>">
                <div class="avatar" style="background-image : url(<%= etu != null ? "./media/"+etu.get("profil") : "" %>)">
                    <input class="file" type="file" value="" />
                    <i class="las la-camera"></i>
                </div> 
                <input class="avatar_input" type="hidden" name="avatar" value="" />
                 <%
                        ArrayList<String> listF = Utils.filiere();
                        int i = 0;
                %>
                <div class="input">
                    <label for="firstname" class="labels">Entrez le prenom</label>
                    <input type="text" name="firstname" value="<%= etu == null ? "" : etu.get("prenomEtudiant") %>">
                </div>
                <div class="input">
                    <label for="lastname" class="labels">Entrez le nom </label>
                    <input type="text" name="lastname" value="<%= etu == null ? "" : etu.get("nomEtudiant") %>">

                </div>
                <div class="input">
                    <div class="btn_radio">
                        <input type="radio" name="sexe" value="femme" <%= etu == null ? "" : etu.get("sexe").equals("femme") ? "checked" : "" %>>
                        <label for="femal">Femme</label><br>
                        <input type="radio" name="sexe" value="homme"  <%= etu == null ? "" : etu.get("sexe").equals("homme") ? "checked" : "" %>>
                        <label for="mal">Homme</label><br>
                    </div>
                </div>
                <div class="input">
                    <label for="adresse" class="labels"> Entrez l'adresse</label>
                    <input type="text" name="adresse" value="<%= etu == null ? "" : etu.get("adresse") %>" /> 
                </div>
                <div class="input" class="labels">
                    <label for="tel">Entrez le numero de telephone </label>
                    <input type="text" name="telephone"  placeholder="---- ----" value="<%= etu == null ? "+509 " : etu.get("telephone") %>">
                </div>
                <div class="input">
                    <label for="lieuNaissance" class="labels">Entrez lieu de naissance </label>
                    <input type="text" name="lieuNaissance" placeholder="Lieu de naissance" value="<%= etu == null ? "" : etu.get("lieu_naissance") %>">

                </div>
                <div class="input">
                    <label for="datenaissance" class="labels">Entrez la date de naissance </label>
                    <input type="date" name="dateNaissance" placeholder="Date" value="<%= etu == null ? "" : etu.get("date_naissance") %>">             
                </div> 

                <div class="input">
                    <label for="personneRef" class="labels">Entrez la personne de reference</label>
                    <input type="text" name="personneRef" placeholder="Nom et prenom" value="<%= etu == null ? "" : etu.get("personne_ref") %>">
                </div> 
                 <div class="input">
                    <label for="telRef" class="labels">Entrez le telephone reference</label>
                    <input type="tel" id="phone" name="telRef" value="<%= etu == null ? "+509 " : etu.get("tel_ref") %>">
                </div> 

                <div class="input">
                    <label for="email" class="labels">Entrez l'email</label>
                    <input type="text" name="email" value="<%= etu == null ? "" : etu.get("email") %>"  placeholder="Email"> 
                </div>


                <div class="input">
                    <label for="cinNif" class="labels">Entrez le CIN/NIF </label>
                    <input type="text" name="cinNif" value="" placeholder="cin/nif" value="<%= etu == null ? "" : etu.get("nif_cin") %>">
                </div> 
                <div class="input">
                    <label for="filiere" class="labels">Entrez la filiere</label>
                    <select name="filiere">
                        <%
                        for(String filiere : listF) {
                        %>
                        <option value= "<%= filiere %>" <%= etu == null ? "" : etu.get("filiere").equals(filiere) ? "selected" : "" %> > <%= filiere %> </option>
                        <%
                            i++;
                        }
                        %>
                    </select>     
                </div>
                 <div class="input">
                    <label for="niveau" class="labels">Choisissez le niveau</label>
                    <select name="niveau">
                        <option></option>
                    </select>
                </div>

                <div class="textarea_style">
                    <label for="memo" class="labels">Memo
                    <textarea name="memo" class ="memo" rows="4" cols="37" maxlength="100" minlength="3" placeholder="Laissez un commentaire ici..."></textarea></label>
                </div> 
            </form>
        </div>
        <div class="button_input">
            <button type="submit" value="Submit" name="submit" id="submit"  style="cursor:pointer;">Ajouter</button>
            <button type="reset" value="Clear" name="clear" id="quit" class="quit"  style="cursor:pointer;">Quiter</button>
        </div>

    </div>
</div>
<div class="main-content">
    <div class="head">
       <div class="view">
           <span class=" las  la-chalkboard-teacher"></span>
           <h2 class=" title_view">Etudiants</h2>
       </div>
       <div class="AcadY">
           <span class="iconY las  la-calendar-check"></span>
           <span class="ActualY">2020-2021</span>
       </div>

   </div>
 
 
<%  
    String idE = (String)request.getParameter("etuId");
    String codeEtudiant =(String)request.getParameter("codeEtudiant");
    String nomE =(String)request.getParameter("firstname");
    String prenomE = (String)request.getParameter("lastname");
    String sexe =(String)request.getParameter("sexe");
    String adresse = (String)request.getParameter("adresse");
    String lieu_naissance = (String)request.getParameter("lieuNaissance");
    String date_naissance = (String)request.getParameter("dateNaissance");
    String telephone = (String)request.getParameter("telephone");
    String email = (String)request.getParameter("email");
    String filiere = (String)request.getParameter("filiere");
    String niveau = (String)request.getParameter("niveau");
    String nif_cin = (String)request.getParameter("cinNif");
    String personne_ref = (String)request.getParameter("personneRef");
    String tel_ref = (String)request.getParameter("telRef");
    String memo = (String)request.getParameter("memo");
    String avatar = (String) request.getParameter("avatar");
    String idEtudiant= (String) request.getParameter("trash");
    
    System.out.println("codeEtudiant "+codeEtudiant);
    System.out.println("Nom "+nomE);
    System.out.println("Prenom "+prenomE);
    System.out.println("sexe "+sexe);
    System.out.println("Adresse "+adresse);
    System.out.println("Lieu de naissance "+lieu_naissance);
    System.out.println("Date de naissance "+date_naissance);
    System.out.println("tel: "+telephone);
    System.out.println("email "+email);
    System.out.println("filiere "+filiere);
    System.out.println("niveau "+niveau);
    System.out.println("nif_cin "+nif_cin);
    System.out.println("Personne de ref "+personne_ref);
    System.out.println("tel ref "+tel_ref);
    System.out.println("memo "+memo);
    System.out.println("avatar "+avatar);
    
    if(idEtudiant !=null){
        db.prepare("DELETE FROM etudiant WHERE idEtudiant=:pIdetudiant");
        db.params("pIdetudiant", idEtudiant);
        
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
    
    if(nomE != null && prenomE != null && sexe !=null && adresse != null && lieu_naissance !=null && date_naissance != null 
        && telephone !=null && email != null && filiere !=null && niveau !=null && nif_cin !=null && personne_ref !=null 
      && tel_ref !=null){
        if(avatar != null){
            avatar = Utils.uploadFile(avatar, this.getServletContext().getRealPath("/")+"media/", null);
        }
        int ID = 0;
        codeEtudiant = Utils.getCode(nomE, prenomE);
        System.out.println("CODE : "+codeEtudiant);
        if(idE == null || idE.length() == 0){
            db.prepare("INSERT INTO etudiant(codeEtudiant, profil,nomEtudiant, prenomEtudiant, sexe, adresse, lieu_naissance, date_naissance, telephone, email, filiere, niveau, nif_cin, personne_ref, tel_ref, memo, annee_academique) "
                + "VALUES (:pcodeEtudiant, :pProfil,:pNomE, :pEPrenom, :pSexe, :pAdresse, :pLieuNaissance, :pDateNaissance, :pTel, :pEmail, :pFiliere, :pNiveau, :pNifCin, :pPersonneRef, :pTelRef, :pMemo, (select id from annee_academique where etat = 'O' limit 1))");
        
        }else{
            db.prepare("Update etudiant set nomEtudiant=:pNomE, prenomEtudiant=:pEPrenom, profil=:pProfil, sexe=:pSexe, adresse=:pAdresse, "
                + "  telephone=:pTel, email= :pEmail, filiere=:pFiliere, niveau=:pNiveau, lieu_naissance=:pLieuNaissance, date_naissance=:pDateNaissance, nif_cin=:pNifCin, personne_ref=:pPersonneRef, tel_ref=:pTelRef, memo=:pMemo "
                + "   WHERE idEtudiant =:pidE");
                 ID = Integer.parseInt(idE);
        }

        System.out.println("ide: "+idE);
        db.params("pcodeEtudiant", codeEtudiant);
        db.params("pNomE", nomE);
        db.params("pEPrenom", prenomE);
        db.params("pSexe", sexe);
        db.params("pAdresse",adresse);
        db.params("pLieuNaissance", lieu_naissance);
        db.params("pDateNaissance", date_naissance);
        db.params("pTel", telephone);
        db.params("pEmail", email);
        db.params("pNiveau", niveau);
        db.params("pFiliere", filiere);
        db.params("pNifCin", nif_cin);
        db.params("pPersonneRef", personne_ref);
        db.params("pTelRef", tel_ref);
        db.params("pMemo", memo);
        db.params("pProfil", avatar);
        db.params("pidE", idE);
        
        
         if(db.execute()){
            %>
            <div class="boxAlert"><%= idE.length() > 0 ? "Modification reussi! " : "Enregistrement reussi!" %></div>
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
            <div class="see">
                <div class="button_head">
                    <button class="print" onclick="printForm('form1')">
                        <span class="print_icon las  la-print"></span>
                        <span class="print_span"></span> 
                    </button>
                    <button class="print">
                        <span class="print_icon las  la-plus-square"></span>
                        <span class="add_span"></span> 
                    </button>
                    <form method="post" action="./panel?res=etudiant" style="display: inline-block">
                        <input type="hidden" name="excel">
                        <input class="file import-file" type="file" value="" />
                        <button class="import print">
                            <span class="print_icon las la-file-upload"></span>
                            <span class="file_span"></span> 
                        </button>
                    </form>
                </div>
                <div class="rang">
                    <form action="rang_entry" method="POST">
                        <div class="rang_input">
                            <select name="filiere">
                                <option value="">Selectionnez le filiere</option>
                                 <%for(String f : listF) {%>
                                <option value="<%= f %>"> <%= f %> </option>
                                <%
                                }%>
                            </select>
                        </div>
                        <div class="rang_input">
                            <select name="niveau">
                                <option></option>
                            </select>
                        </div>

                    </form>
                </div>
            <div class="forme_print" id="form1">                 
                <div class="colums">
                    <div class="column"> Code</div>
                    <div class="column">Profil</div>
                    <div class="column">Nom</div>
                    <div class="column">Prenom</div>
                    <div class="column">Filiere</div>
                    <div class="column"> Niveau</div>
                    <div class="column"> Statut</div>
                    <div class="column">operation</div>

                </div>
                <div class="allrows">
                    <% 
                        db = DBConnect.getCon();
                        db.prepare("SELECT * FROM etudiant");
                        if(db.execute()){
                           HashMap<String, Object> data;
                           while(db.hasNext()){
                               data = db.fetch();
                    %>
                        <div class="rows">
                            <div class="row"><%= data.get("codeEtudiant") %></div>
                            <div class="row profil_img" style="justify-content: center; background-image: url(./media/<%= data.get("profil") == null ? "Dr_dada.png" : data.get("profil") %>);"></div>
                            <div class="row point nom"><%= data.get("nomEtudiant") %></div>
                            <div class="row point prenom"><%= data.get("prenomEtudiant") %></div>
                            <div class="row point filiere"><%= data.get("filiere") %></div>
                            <div class="row point niveau"><%= data.get("niveau") %></div>
                            <div class="row"><%= data.get("etat") %></div>
                            <div class="row icons_operation">
                                <form method="post" action="./panel?res=etudiant">
                                    <input type="hidden" name="modifier" value="<%= data.get("idEtudiant") %>">
                                    <button type="submit" class=" pen las  la-pencil-alt"></button>
                                </form>                        
                                <form method="post" action="./panel?res=etudiant">
                                    <input type="hidden" name="trash" value="<%= data.get("idEtudiant") %>">
                                    <button href="#"class=" trash las la-trash-alt" type="submit"></button>
                                </form>
                                <i class="las la-angle-down"></i>
                            </div>
                             <div class="row-info">
                                <div class="row Iprofil_img" style="justify-content: center; background-image: url(./media/<%= data.get("profil") == null ? "Dr_dada.png" : data.get("profil") %>);"></div>
                                <div>
                                <div class="list_info">
                                   <div class="info code"> 
                                       <span class="span_info">Code:</span>
                                       <span><%= data.get("codeEtudiant") %></span>
                                   </div>
                                   <div class="info nom">
                                       <span class="span_info">Nom:</span>
                                       <span><%= data.get("nomEtudiant") %></span>
                                   </div>
                                   <div class="info prenom">
                                       <span class="span_info">Prenom:</span>
                                       <span><%= data.get("prenomEtudiant") %></span>
                                   </div>
                                   <div class="info sexe">
                                       <span class="span_info">Sexe:</span>
                                       <span><%= data.get("sexe") %></span>
                                   </div>
                                   <div class="info adresse">
                                       <span class="span_info">Adress:</span>
                                       <span><%= data.get("adresse") %></span>
                                   </div>
                                   <div class="info telephone">
                                       <span class="span_info">Tel:</span>
                                       <span><%= data.get("telephone") %></span>
                                   </div>
                                    <div class="info email">
                                         <span class="span_info">Email:</span>
                                         <span><%= data.get("email") %></span>
                                    </div>
                                   <div class="info lieu_naissance">
                                       <span class="span_info">Lieu Naissance:</span>
                                       <span><%= data.get("lieu_naissance") %></span>
                                   </div>
                                   <div class="info date_naissance">
                                       <span class="span_info">Date de naissance:</span>
                                       <span><%= data.get("date_naissance") %></span>
                                   </div>
                                   <div class="info personneRef">
                                       <span class="span_info">Personne de reference:</span>
                                       <span><%= data.get("personne_ref") %></span>
                                   </div>
                                   <div class="info tel_ref">
                                       <span class="span_info"> Tel personne de reference:</span>
                                       <span><%= data.get("tel_ref") %></span>
                                   </div>
                                   <div class="info niveau">
                                       <span class="span_info"> Niveau:</span>
                                       <span><%= data.get("niveau") %></span>
                                   </div>
                                   <div class="info filiere">
                                       <span class="span_info">Filiere:</span>
                                       <span><%= data.get("filiere") %></span>
                                   </div>
                                   <div class="info cin_nif">
                                       <span class="span_info">CIN/NIF: </span>
                                       <span><%= data.get("nif_cin") %></span>
                                   </div>

                                   <div class="info memo">
                                       <span class="span_info">Memo: </span>
                                       <span><%= data.get("memo") %></span>
                                   </div>
                                   <div class="etats">
                                        <form method="post" action="">
                                            <div class="etat">
                                                <input type="hidden" name="etat" value="">
                                                <button type="submit" class="etat-btn">A</button>
                                            </div>
                                            <div>
                                                <input type="hidden" name="etat" value="">
                                                <button class="etat-btn" type="submit">E</button>
                                            </div>
                                            <div>
                                                <input type="hidden" name="etat" value="">
                                                <button class="etat-btn" type="submit">D</button>
                                            </div>
                                            <div>
                                                <input type="hidden" name="etat" value="">
                                                <button class="etat-btn" type="submit">T</button>
                                            </div>

                                        </form>
                                    </div>
                                </div> 
                                </div>
                            </div>
                        </div>

                    <%}

                        }
                    %>
                </div>
            </div>
        </div>
    </div>
</div>
<style>
    .icons_operation button {
        border: none;
        background: unset;
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
    .button_head .file_span::before{
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
    .button_head .file_span::after{
        content: "Importer";
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
        padding: 2rem 3rem 2rem 2rem;
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
<script src="./js/search.js"></script>