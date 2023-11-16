const OlivaContract = artifacts.require("OlivaContract")
contract("OlivaContract",() =>{
    before(async() => {
       this.olivaContract = await OlivaContract.deployed
     
    })

    it('El contrato se ha desplegado con exito',async() => {
        const address = this.olivaContract.address
        assert.notEqual(address,null);
        assert.notEqual(address,undefined);
        assert.notEqual(address,0x0);
        assert.notEqual(address,"");



    }) 
})
