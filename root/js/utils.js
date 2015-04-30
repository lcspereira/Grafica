/*****************************************
 * buscaCep 
 *****************************************
 * Requisição AJAX para preencher o endereço
 * baseado no CEP.
 *
 * @param cep: CEP do endereço.
 *****************************************/

function buscaCep (cep) {
    var jqxhr;
    var msg      = document.createTextNode ("Aguarde...");
    var linhaCep = (document.getElementsByTagName('tbody'))[0].childNodes[6];
    var msgDone;
    var urlBuscaCep;

    // Monta a URL 
    if (window.location.pathname.match (/\/clientes\/editar\/\d{1,}/)) {
        urlBuscaCep = "../busca_cep/" + cep;
    } else {
        urlBuscaCep = "busca_cep/" + cep;
    }

    linhaCep.appendChild (msg);
    jqxhr   = $.ajax ({
        url: urlBuscaCep,
        dataType: "json",
     }, 30000)  
     .done (function (dadosCep) {
          msgDone                                   = document.createTextNode (dadosCep.status);
          document.getElementById('endereco').value = dadosCep.street;
          document.getElementById('bairro').value   = dadosCep.neighborhood;
          document.getElementById('cidade').value   = dadosCep.location;
          linhaCep.replaceChild (msgDone, msg);
     });
}

/******************************************/


function punctData (campoData) {
    if (campoData.value.length == 2 || campoData.value.length == 5) {
        campoData.value += "/";
    }
}
