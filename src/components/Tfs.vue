<template>
  <q-layout ref="layout" view="lHh lPr lFf" :right-breakpoint="1100">
    <!-- Header -->
    <q-toolbar slot="header">
      <q-toolbar-title>
        Tracy Fine Products
      </q-toolbar-title>
      <q-btn flat @click="$refs.layout.toggleRight()">
        <q-icon name="menu" />
      </q-btn>
    </q-toolbar>

    <div slot="right">
      <q-list no-border link inset-separator>
        <q-list-header>Day Setup</q-list-header>
        <q-side-link item icon="mail" @to="openModal()">
          <q-item-main label="Start the day" />
        </q-side-link>
      </q-list>
    </div>

    <q-btn icon-right="add" @click="startNewTransaction()" color="primary" class="full-width">Start New Transaction</q-btn>

    <modal-test ref="modalTest" class="full-width"></modal-test>

    <daily-summary ref="dailySummary"></daily-summary>

    <transactions ref="transactions" :page="page" :tfpData="tfpData"></transactions>

    <div id="stepper-section" class="list" style="overflow: scroll;" v-if="page == 'new-transactions'">
      <q-collapsible id="chooseProduct" opened icon="explore" :img="selectedProductTypeImage" :label="productTypeMessage" group="tx" ref="chooseProduct">
        <div>
          <div class="row wrap">
            <div class="width-4of12 auto">
              <button :id="'btn'+item.id" class="tx-img-button" @click="selectProductType(item)" v-for="item in tfpData.productTypes">
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
              <button :id="'btn'+item.id" class="tx-img-button" @click="selectProduct(item)" v-for="item in selectedProductTypeItems">
                <img :src= "'./statics/'+item.img" :alt="item.desc" style="width: 128px" />
                <br/>
                <span class="label auto wrap" style="font-size: 8pt;">{{item.desc}}</span> 
              </button>
            </div>
          </div>
        </div>
      </q-collapsible>
      <q-collapsible id="chooseQty" icon="shopping_cart" label="Choose Quantity" group="tx" ref="chooseQty">
        <div class="">
          <div class="row wrap">
            <div class="width-1of1 auto">
              <div class="row" style="margin-bottom: 5px;">
                <label class="width-1of5">Quantity:</label>
                <div class="auto" style="background-color: #cacaca;">
                  <q-numeric class="width-1of5" v-model="qty" :min="1" :max="99"></q-numeric>
                </div>
              </div>
              <div class="row">
                <label class="width-1of5">Price:</label>
                <input class="auto" style="background-color: #cacaca;" v-model="price" placeholder="Unit price">
              </div>
            </div>
          </div>
          <div class="row wrap">
            <div class="width-1of12 auto">
                <button class="primary" style="width: 250px; margin-bottom: 5px;" @click="finish()">Finish and Pay</button>
                <button class="primary" style="width: 250px; margin-bottom: 5px;" @click="saveAndAddNew()">Add Another Item</button>
            </div>
          </div>
        </div>
      </q-collapsible>

      <hr/><br/><br/>

      <div class="card">
        <div class="card-title bg-primary text-white">
          Finish Tx
        </div>
        <div class="card-content card-force-top-padding">
          <div class="row gutter wrap justify-stretch content-center">
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
            <div class="width-1of1 auto">
              <div class="row" style="margin-bottom: 5px;">
                <label class="width-1of5">Type:</label>
                <div class="auto tx-switch">
                  <label class="auto">pl</label>
                  <q-toggle class="auto" v-model="pp" @input="selectPayType"></q-toggle>
                  <label class="auto">pp</label>
                </div>
              </div>
              <div class="row" style="margin-bottom: 5px;">
                <label class="width-1of5">Tx Price:</label>
                <input class="auto" style="background-color: #cacaca;" v-model="runningTotal" placeholder="Total">
              </div>
              <div class="row" style="margin-bottom: 5px;">
                <label class="row width-1of5">+</label>
                <input class="auto" style="background-color: #cacaca;" v-model="transactionTax" placeholder="Tax">
              </div>
              <div class="row" style="margin-bottom: 5px;">
                <label class="row width-1of5">=</label>
                <input class="auto" style="background-color: #cacaca;" v-model="transactionTotal" placeholder="Pay">
              </div>
            </div>
          </div>
          <div class="row wrap">
            <div class="width-1of1">
                <button class="primary width-1of1" style="width: 250px; margin-bottom: 5px;" @click="startNewTransaction()">
                  Start New Transaction<i class="on-right">add</i>
                </button>
                <button class="primary width-1of1" style="width: 250px; margin-bottom: 5px;" @click="transactionList()">
                  Back to Transaction List
                </button>
            </div>
          </div>
        </div>
      </div>
    </div>
    <q-card>
      <button class="primary" @click="saveToLocalStorage()">
        Save to Local Storage
      </button>
      <button class="primary" @click="openModal()">
        Open Modal
      </button>
    </q-card>
  </q-layout>
</template>

<script>
  import {
    dom,
    event,
    openURL,
    QLayout,
    QToolbar,
    QToolbarTitle,
    QBtn,
    QIcon,
    QList,
    QListHeader,
    QItem,
    QItemSide,
    QItemMain,
    QModal,
    QCard,
    QCardTitle,
    QCardMain,
    QCardActions,
    QCardMedia,
    QCardSeparator,
    QSideLink,
    LocalStorage
  } from 'quasar'

  // import { LocalStorage, Dialog } from 'quasar'
  import TfpData from '../TfpData.json'
  import ModalTest from './ModalTest.vue'
  import DailySummary from './DailySummary.vue'
  import Transactions from './Transactions.vue'

  // import DayStart from './DayStart1.vue'
  // import DayStart1 from './DayStart1.vue'

  // if (LocalStorage.isEmpty()) {
  // alert('loading tfpData from json')
  LocalStorage.set('tfpData', TfpData)
  // }

  let tfpData = LocalStorage.get.item('tfpData')
  // alert('tfpdata loaded')
  // alert(JSON.stringify(tfpData))

  export default {
    name: 'app',
    components: {
      // DayStart
      dom,
      event,
      openURL,
      QLayout,
      QToolbar,
      QToolbarTitle,
      QBtn,
      QIcon,
      QList,
      QListHeader,
      QItem,
      QItemSide,
      QItemMain,
      QModal,
      QCard,
      QCardTitle,
      QCardMain,
      QCardActions,
      QCardMedia,
      QCardSeparator,
      QSideLink,
      ModalTest,
      DailySummary,
      Transactions
    },

    data () {
      return {
        tfpData: tfpData,
        // tfpData: LocalStorage.get.item('tfpData'),

        // settings
        taxRate: 0.05,

        // state values
        page: 'transactions',
        selectedProductTypeImage: '',
        productTypeMessage: 'Select a Product',
        selectedItemImage: '',
        itemMessage: 'Select an Item',

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
        currTx: {},

        productTypes: TfpData,
        txId: 1,
        newItems: [],
        newTransaction: {},

        currentShow: {},

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

    mounted: function () {
      // alert('In mounted')

      // alert(JSON.stringify(this.TfpData))

      if (typeof tpfData !== 'undefined') alert('tfpData defined')

      if (this.tpfData == null) {
        // alert('tfpData null')
      }
      else {
        // alert('tfpData not null')
      }

      // if (this.tpfData) alert('tfpData OK'); else alert('tfpData not OK')
      // this.tfpData ? alert(this.tfpData) : alert('tfpData is null')
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
      selectedTransactionItems (tx) {
        if (this.tfpData.transactions === '') return null
        let _obj = this.tfpData.transactionItems
        let _filtered = {}
        Object.keys(_obj).forEach(function (key) {
          if (_obj[key].transactionId === tx.id) _filtered[key] = _obj[key]
        })
        // alert(JSON.stringify(_filtered, null, 4))
        return _filtered
      },

      startNewTransaction: function () {
        this.page = 'new-transactions'
        let _txId = this.txId += 1
        this.newTransaction = {
          id: _txId,
          txNumber: _txId,
          txTime: Date.now(),
          dayInfoId: 1,
          user: 1,
          salesperson: 1,
          pp_or_pl: 0,
          total: 0,
          tax: 0
        }
        // alert(JSON.stringify(this.newTransaction, null, 4))
      },

      saveToLocalStorage: function () {
        LocalStorage.set('key', 'value')
        LocalStorage.set('tfpData', this.tfpData)
      },

      selectProductType: function (productType) {
        this.productTypeSelected = productType
        this.productType = productType
        this.selectedProductTypeImage = './statics/' + productType.img
        this.productTypeMessage = productType.name + ' selected'
        this.$refs['chooseItem'].open()
      },

      selectProduct: function (item) {
        this.product = item
        this.price = item.price
        this.selectedItemImage = './statics/' + item.img
        this.itemMessage = this.product.desc + ' selected'
        this.$refs['chooseQty'].open()
      },

      selectPayType: function (val) {
        this.calculateTransactionTotals()
      },

      finish: function () {
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
        this.calculateTransactionTotals()
        this.saveTransaction()
      },

      calculateTransactionTotals: function () {
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
        // alert(JSON.stringify(this.newItems))
      },

      saveTransaction: function () {
        let _tfpData = this.tfpData
        this.newTransaction.pp_or_pl = this.pp ? 'pl' : 'pp'
        this.newTransaction.total = this.transactionTotal
        this.newTransaction.tax = this.transactionTax
        _tfpData.transactions[this.newTransaction.id] = this.newTransaction

        let _newTx = this.newTransaction
        let _id = 3
        this.newItems.forEach(function (item) {
          let _tmp = {
            id: _id++,
            transactionId: _newTx.id,
            productTypeId: item.productTypeId,
            productTypeDesc: item.productTypeDesc,
            productItemId: item.productItemId,
            productItemDesc: item.productItemDesc,
            qty: item.qty,
            price: item.price,
            tax: item.tax
          }
          _tfpData.transactionItems[_tmp.id] = _tmp
        })
        this.tfpData = _tfpData
      },

      saveAndAddNew: function () {
        this.finish()
        this.$refs['chooseProduct'].open()
      },

      transactionList: function () {
        this.page = 'transactions'
      },

      // startDay: function () {
      // this.$refs.dayStart.open()
      // }

      openModal: function () {
        this.$refs.modalTest.open()
      }
    }
  }
</script>

<style>
</style>
