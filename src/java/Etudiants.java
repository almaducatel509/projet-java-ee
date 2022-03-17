/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 *
 * @author Wildar
 */
public class Etudiants {
    private String code;
    private String nom;
    private String prenom;
    private String sexe;
    private String adresse;
    private String lieuNaiss;
    private String dateNaiss;
    private String telephone;
    private String email;
    private String filiere;
    private String niveau;
    private String NifCin;
    private String personneReference;
    private String photo;
    private String anneeAcademique;
    private String Etat;
    private String memos;
    
    public Etudiants(){}

    public Etudiants(String code, String nom, String prenom, String sexe, String adresse, String lieuNaiss, String dateNaiss, String telephone, String email, String filiere, String niveau, String NifCin, String personneReference, String photo, String anneeAcademique, String Etat, String memos) {
        this.code = code;
        this.nom = nom;
        this.prenom = prenom;
        this.sexe = sexe;
        this.adresse = adresse;
        this.lieuNaiss = lieuNaiss;
        this.dateNaiss = dateNaiss;
        this.telephone = telephone;
        this.email = email;
        this.filiere = filiere;
        this.niveau = niveau;
        this.NifCin = NifCin;
        this.personneReference = personneReference;
        this.photo = photo;
        this.anneeAcademique = anneeAcademique;
        this.Etat = Etat;
        this.memos = memos;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getNom() {
        return nom;
    }

    public void setNom(String nom) {
        this.nom = nom;
    }

    public String getPrenom() {
        return prenom;
    }

    public void setPrenom(String prenom) {
        this.prenom = prenom;
    }

    public String getSexe() {
        return sexe;
    }

    public void setSexe(String sexe) {
        this.sexe = sexe;
    }

    public String getAdresse() {
        return adresse;
    }

    public void setAdresse(String adresse) {
        this.adresse = adresse;
    }

    public String getLieuNaiss() {
        return lieuNaiss;
    }

    public void setLieuNaiss(String lieuNaiss) {
        this.lieuNaiss = lieuNaiss;
    }

    public String getDateNaiss() {
        return dateNaiss;
    }

    public void setDateNaiss(String dateNaiss) {
        this.dateNaiss = dateNaiss;
    }

    public String getTelephone() {
        return telephone;
    }

    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getFiliere() {
        return filiere;
    }

    public void setFiliere(String filiere) {
        this.filiere = filiere;
    }

    public String getNiveau() {
        return niveau;
    }

    public void setNiveau(String niveau) {
        this.niveau = niveau;
    }

    public String getNifCin() {
        return NifCin;
    }

    public void setNifCin(String NifCin) {
        this.NifCin = NifCin;
    }

    public String getPersonneReference() {
        return personneReference;
    }

    public void setPersonneReference(String personneReference) {
        this.personneReference = personneReference;
    }

    public String getPhoto() {
        return photo;
    }

    public void setPhoto(String photo) {
        this.photo = photo;
    }

    public String getAnneeAcademique() {
        return anneeAcademique;
    }

    public void setAnneeAcademique(String anneeAcademique) {
        this.anneeAcademique = anneeAcademique;
    }

    public String getEtat() {
        return Etat;
    }

    public void setEtat(String Etat) {
        this.Etat = Etat;
    }

    public String getMemos() {
        return memos;
    }

    public void setMemos(String memos) {
        this.memos = memos;
    }
    
    
    
    
}
