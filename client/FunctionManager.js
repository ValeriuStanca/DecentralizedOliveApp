const oliveForm = document.querySelector("#crearProductoForm");

oliveForm.addEventListener("submit",e => {
    e.preventDefault();
    //const IdProducto = ethers.utils.formatBytes32String(oliveForm.value);
    const fechaProduccion = new Date(oliveForm["fechaProduccion"].value).getTime() / 1000;
    App.createProduct(oliveForm["Id"].value,oliveForm["title"].value,fechaProduccion,oliveForm["price"].value); 

   
});

