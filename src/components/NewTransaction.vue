<template>
  <div id="stepper-section" class="list" style="overflow: scroll;" v-if="currPage == 'new-transactions'">
    <q-collapsible id="chooseProduct" opened icon="explore" :img="selectedProductTypeImage" :label="productTypeMessage" group="tx" ref="chooseProduct">
      <div>
        <div class="row wrap">
          <div class="width-4of12 auto">
            <button :id="'btn'+item.id" class="tx-img-button" @click="selectProductType(item)" 
                v-for="item in tfpData.productTypes" v-bind:key="item.name">
              <img :src= "'./statics/'+item.img" :title="item.name" style="width: 128px" />
              <br/>
              <span class="label">{{item.name}}</span>
            </button>
          </div>
        </div>
      </div>
    </q-collapsible>
    <q-collapsible id="chooseItem" icon="perm_identity" :img="selectedItemImage" :label="itemMessage" group="tx" ref="chooseItem">
      <div>
        <div class="row wrap">
          <div class="width-1of12 auto">
            <button :id="'btn'+item.id" class="tx-img-button" @click="selectProduct(item)" 
                v-for="item in selectedProductTypeItems" v-bind:key="item.name">
              <img :src= "'./statics/'+item.img" :alt="item.desc" style="width: 128px" />
              <br/>
              <span class="label auto wrap" style="font-size: 8pt;">{{item.desc}}</span>
            </button>
          </div>
        </div>
      </div>
    </q-collapsible>
    <q-collapsible id="chooseQty" icon="shopping_cart" :label="qtyMessage" group="tx" ref="chooseQty">
      <q-field
        icon="today"
        label="Quantity">
        <q-slider v-model="qty" :min="1" :max="50" label-always/>
      </q-field>
      <q-field icon="today" label="Price">
        <q-input v-model="price"  placeholder="Unit price" />
      </q-field>
      <q-btn icon-right="add" @click="finish()" color="primary">Finish and Pay</q-btn>
      <q-btn icon-right="add" @click="saveAndAddNew()" color="primary">Add Another Item</q-btn>
    </q-collapsible>

    <q-card>
      <q-card-title>
        Finish Tx
      </q-card-title>
      <q-card-separator />
      <q-card-main ref="finish-tx-table">
        <q-data-table class="width-1of1 auto" style="border: none;" :data="newItems" :config="config" :columns="columns">
          <template slot="selection" scope="selection">
            <button class="primary clear" @click="changeMessage(selection)">
              <i>edit</i>
            </button>
            <button class="primary clear" @click="deleteRow(selection)">
              <i>delete</i>
            </button>
          </template>
        </q-data-table>
      </q-card-main>
      <q-card-separator />
      <q-card-main ref="finish-tx-data">
        Card&nbsp;&nbsp;<q-toggle v-model="pp" label="Cash" @change="setTaxValues()" />
        <q-field icon="today" label="Tx Price">
          <q-input v-model="runningTotal"  placeholder="Total" />
        </q-field>
        <q-field icon="today" label="+">
          <q-input v-model="transactionTax"  placeholder="Tax" />
        </q-field>
        <q-field icon="today" label="=">
          <q-input v-model="transactionTotal"  placeholder="Pay" />
        </q-field>
      </q-card-main>

      <q-btn icon-right="add" @click="saveAndStartNew()" color="primary">Start New Transaction</q-btn>
      <q-btn icon-right="add" @click="transactionList()" color="primary">Back to Transaction List</q-btn>
    </q-card>
  </div>
</template>

<script>
  import {
    QBtn,
    QCard,
    QCardActions,
    QCardMain,
    QCardMedia,
    QCardSeparator,
    QCardTitle,
    QCollapsible,
    QDataTable,
    QField,
    QIcon,
    QInput,
    QList,
    QListHeader,
    QItem,
    QItemSide,
    QItemMain,
    QLayout,
    QModal,
    QPopover,
    QSelect,
    QSideLink,
    QSlider,
    QToggle,
    QToolbar,
    QToolbarTitle
  } from 'quasar'

  export default {
    components: {
      QBtn,
      QCard,
      QCardActions,
      QCardMain,
      QCardMedia,
      QCardSeparator,
      QCardTitle,
      QCollapsible,
      QDataTable,
      QField,
      QIcon,
      QInput,
      QList,
      QListHeader,
      QItem,
      QItemSide,
      QItemMain,
      QLayout,
      QModal,
      QPopover,
      QSelect,
      QSideLink,
      QSlider,
      QToggle,
      QToolbar,
      QToolbarTitle
    },

    props: ['tfpData', 'showId', 'txId'],

    data () {
      return {
        currTx: 0,
        currPage: '',

        // settings
        taxRate: 0.05,

        // state values
        selectedProductTypeImage: '',
        productTypeMessage: 'Select a Product',
        selectedItemImage: '',
        itemMessage: 'Select an Item',
        qtyMessage: 'Choose Quantity',

        // item values
        qty: 1,
        price: 0,
        tax: 0,
        total: 0,

        // day start values
        dateOfShow: new Date(),
        market: 'Millarville',
        teamName: 'Team Sean',

        // transaction values
        runningTotal: 0,
        taxTotal: 0,
        transactionTax: 0,
        transactionTotal: 0,
        pp: false,
        productTypeSelected: '',
        productType: '',
        product: '',
        _txId: 0,

        // productTypes: TfpData,
        productTypes: this.tfpData,
        // txId: 1,
        newItems: [],
        newTransaction: {},

        // transaction arrays
        config: {
          rowHeight: '25px', // [REQUIRED] Set the row height
          title: 'Transaction Items',
          noHeader: false,
          refresh: true,
          columnPicker: false,
          leftStickyColumns: 0,
          rightStickyColumns: 0,
          bodyStyle: {
            maxHeight: '500px'
          },
          selection: 'single',
          messages: {
            noData: '<i>warning</i> No data available to show.',
            noDataAfterFiltering: '<i>warning</i> No results. Please refine your search terms.'
          },

          // (optional) Override default labels. Useful for I18n.
          labels: {
            rows: 'Items',
            selected: {
              singular: 'item selected.',
              plural: 'items selected.'
            },
            clear: 'clear',
            all: 'All'
          }
        },
        columns: [
          {
            label: 'Type', // [REQUIRED] Column name
            field: 'productTypeDesc', // [REQUIRED] Row property name
            width: '50px' // [REQUIRED] Column width
          },
          {
            label: 'Product',
            field: 'productItemDesc',
            width: '100px'
          },
          {
            label: 'Qty',
            field: 'qty',
            width: '20px'
          },
          {
            label: 'Price',
            field: 'price',
            width: '30px'
          },
          {
            label: 'Tax',
            field: 'tax',
            width: '30px'
          },
          {
            label: 'Total',
            field: 'total',
            width: '40px'
          },
          {
            label: 'Running',
            field: 'runningTotal',
            width: '50px'
          }
        ]
      }
    },

    computed: {
      selectedProductTypeItems () {
        if (this.productTypeSelected === '') return null
        let productTypeSelected = this.productTypeSelected
        let obj = this.tfpData.productItems
        let filtered = {}
        Object.keys(obj).forEach(function (key) {
          if (obj[key].productTypeId === productTypeSelected.id) filtered[key] = obj[key]
        })
        return filtered
      }
    },

    methods: {
      startNewTransaction () {
        alert('in startNewTransactions')
        this.currPage = 'new-transactions'
        this.newItems = []
        this._txId = this.txId + 1
        this.newTransaction = {
          id: this.txId,
          txNumber: this.txId,
          txTime: Date.now(),
          dayInfoId: 1,
          user: 1,
          salesperson: 1,
          pp_or_pl: 0,
          total: 0,
          tax: 0
        }
        alert(JSON.stringify(this.newTransaction))
      },

      selectProductType (productType) {
        this.productTypeSelected = productType
        this.productType = productType
        this.selectedProductTypeImage = './statics/' + productType.img
        this.productTypeMessage = productType.name + ' selected'
        this.$refs.chooseItem.open()
      },

      selectProduct (item) {
        this.product = item
        this.price = item.price
        this.selectedItemImage = './statics/' + item.img
        this.itemMessage = this.product.desc + ' selected'
        this.$refs.chooseQty.open()
      },

      setTaxValues () {
        this.calculateTransactionTotals()
      },

      finish () {
        this.qtyMessage = this.qty + ' chosen'
        let _tax = this.pp ? 0 : this.taxRate
        this.newItems.push({
          productTypeId: this.productTypeSelected.id,
          productTypeDesc: this.productTypeSelected.desc,
          productItemId: this.product.id,
          productItemDesc: this.product.desc,
          qty: this.qty,
          price: this.price,
          tax: _tax,
          total: (this.price + (this.price * _tax)) * this.qty,
          runningTotal: this.runningTotal += (this.price + (this.price * _tax)) * this.qty
        })
        this.$refs.chooseQty.close()
        this.calculateTransactionTotals()
      },

      calculateTransactionTotals () {
        let tempArr = []
        let _runningTotal = 0
        let _runningTotalTax = 0
        let _tax = this.pp ? 0 : this.taxRate

        this.newItems.forEach(function (item) {
          _runningTotal += item.price * item.qty
          _runningTotalTax += (item.price * _tax) * item.qty
          tempArr.push({
            productTypeId: item.productTypeId,
            productTypeDesc: item.productTypeDesc,
            productItemId: item.productItemId,
            productItemDesc: item.productItemDesc,
            qty: item.qty,
            price: item.price,
            tax: item.price * _tax * item.qty,
            total: (item.price + (item.price * _tax)) * item.qty,
            runningTotal: _runningTotal + _runningTotalTax
          })
        })
        this.newItems = tempArr
        this.runningTotal = _runningTotal
        this.transactionTax = _runningTotalTax
        this.transactionTotal = this.runningTotal + this.transactionTax
      },

      saveTransaction () {
        alert('in saveTransaction')
        let _tfpData = this.tfpData
        this.newTransaction.pp_or_pl = this.pp ? 'pl' : 'pp'
        this.newTransaction.total = this.transactionTotal
        this.newTransaction.tax = this.transactionTax
        _tfpData.transactions[this.newTransaction.id] = this.newTransaction
        let _id = Math.max(...Object.keys(_tfpData.transactionItems).map(k => _tfpData.transactionItems[k]['id'])) + 1
        alert('calling forEach')
        let _txId = this.newTransaction.id
        this.newItems.forEach(function (item) {
          _tfpData.transactionItems[_id] = {
            id: _id++,
            transactionId: _txId,
            productTypeId: item.productTypeId,
            productTypeDesc: item.productTypeDesc,
            productItemId: item.productItemId,
            productItemDesc: item.productItemDesc,
            qty: item.qty,
            price: item.price,
            tax: item.tax
          }
        })
        this.tfpData = _tfpData
      },

      saveAndAddNew () {
        this.finish()
        this.$refs.chooseProduct.open()
      },

      saveAndStartNew () {
        this.saveTransaction()
        this.startNewTransaction()
        this.$refs.chooseProduct.open()
      },

      transactionList () {
        this.currPage = 'transactions'
        // have to deal with asynchronousity so that the transactions section hides
        this.$nextTick(function () {
          this.saveTransaction()
          this.$emit('transactionSaved', [this.tx, this.newTxId, this.transactionTotal, this.currPage])
        })
      },

      loadTransactionIntoTable () {
        // this.newTransaction = tfpData.transactions[editTxId]

        // this.$refs.chooseQty.close()
        // this.calculateTransactionTotals()
      }
    }
  }
</script>
