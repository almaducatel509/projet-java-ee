
if ( window.history.replaceState ) {
    window.history.replaceState( null, null, window.location.href );
}

var niveau = ["EUF", "L1","L2","L3","Spec1","Spec2", "Internat","Social"];

function readFile(file, cb){
    var vAvatar = $(this).parent();
    var reader = new FileReader();
    reader.readAsDataURL(file);
    reader.onload = function(){
        cb(reader.result);
    };
}

Zepto('body').on('change', '[name="filiere"]', function(){
    var filiere = $(this).val();
    console.log('FILIERE',filiere)
    var limite = filiere == "Faculte de Médecine" ? 8 : filiere == "Faculte des Sciences et de Génie" || filiere == "Faculte d'Agronomie" ? 6 : 4; 
    var option = "";
    for(var i = 0; i< limite; i++){
        option += "<option value='"+niveau[i]+"'>"+ niveau[i]+"</option>";
    }
    $(this).parent().parent().find('[name="niveau"]').html(option);
}).on('click', '.avatar', function(){
    $(this).find('.file').click();
}).on('change', '.avatar .file', function(){
    var image = this.files[0];
    $(this).val('');
    if(!/\.(jp(e)g|png)$/i.test(image.name)){
        window.confirm("Vous devez sélectionner un fichier image de type jpg, jpeg, png");
        return;
    }
    readFile(image, function(result){
        vAvatar.css('background-image', 'url('+result+')');
        $('.avatar_input').val(result);  
    })
} ).on('click', '#user', function(){
console.log("onclick user ");
    $('.user_icon').toggleClass('active');
}).on('click', '.rows', function(){
    $(this).toggleClass('active');
}).on('click','.etatActive', function(){
    $('.etat__btn').toggleClass('active');
}).on('click','.add_span',function(){
    $('.popup_entry').addClass('active').find('[disabled]').removeAttr('disabled');
    $('.popup_entry [type="hidden"]').val('');
}).on('click','.quit',function(){
    $('.popup_entry').removeClass('active');
    $('.form_entry')[0].reset();
}).on('click', '#submit', function(){
    $('.form_entry').find('[disabled]').removeAttr('disabled')
    $('.form_entry').submit();
}).on('click', '.import', function(e){
    e.preventDefault();
    $(this).parent().find('[type]').click();
}).on('change', '.import-file', function(){
    var file = this.files[0],
        parent = $(this).parent();
    $(this).val('');
    if(!/\.xls$/i.test(file.name)){
        window.confirm("Vous devez sélectionner un fichier excel de type xls");
        return;
    }
    readFile(file, function(result){
        parent.find('[name="excel"]').val(result);
        parent.submit();
    });
})
$('[name="filiere"]').trigger('change');

