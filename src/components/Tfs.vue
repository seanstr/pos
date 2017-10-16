<template>
  <q-layout ref="layout" view="lHh lPr lFf" :right-breakpoint="1100">
    <!-- Header -->
    <q-toolbar slot="header">
      <q-toolbar-title>
        TFP
      </q-toolbar-title>
      <q-btn flat @click="$refs.layout.toggleRight()">
        <q-icon name="menu" />
      </q-btn>
    </q-toolbar>

    <div slot="right">
      <q-list no-border link inset-separator>
        <q-list-header>Day Setup</q-list-header>
          <q-list item-separator link>
            <q-item @click="openDayStart()">
              <q-item-main label="Start the day" />
            </q-item>
            <q-item @click="saveToLocalStorage()">
              <q-item-main label="Save Data" />
            </q-item>
            <q-item @click="clearLocalStorageTransactions()">
              <q-item-main label="Clear Data" />
            </q-item>
            <q-item @click="reloadTFPData()">
              <q-item-main label="Reload Data from File" />
            </q-item>
            <q-item 
              @click="$refs.basicModal.open()">
              <q-item-main label="Display TFP Data" />
            </q-item>
          </q-list>
      </q-list>
    </div>

    <q-btn icon-right="add" @click="startNewTransaction()" color="primary" class="full-width">Start New Transaction</q-btn>

    <day-start ref="dayStart" class="full-width" :currentShow="currentShow" :tfpData="tfpData" v-on:day_saved="daySaved"></day-start>

    <daily-summary ref="dailySummary" :currentShow="currentShow" :tfpData="tfpData" :currentShowID="currentShowId"></daily-summary>

    <transactions ref="transactions" :page="page" :tfpData="tfpData"></transactions>

    <div id="stepper-section" class="list" style="overflow: scroll;" v-if="page == 'new-transactions'">
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
    <q-modal ref="basicModal">
      <h4>Current Data View</h4>
      <pre>
       {{JSON.stringify(tfpData, null, 2)}}
      </pre>
      <p>
      </p>
      <q-btn color="primary" @click="$refs.basicModal.close()">Close</q-btn>
    </q-modal>
  </q-layout>
</template>

<script>
  import {
    date,
    dom,
    event,
    openURL,
    LocalStorage,
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

  // load from JSON file
  import TfpData from '../TfpData.json'

  // load from LocalStorage
  let tfpData = LocalStorage.get.item('tfpData')
  
  import DailySummary from './DailySummary.vue'
  import Transactions from './Transactions.vue'
  import DayStart from './DayStart.vue'

  export default {
    name: 'app',
    components: {
      date,
      dom,
      event,
      openURL,
      LocalStorage,
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
      QToolbarTitle,

      DailySummary,
      Transactions,
      DayStart
    },

    data () {
      return {
        tfpData: tfpData, // use LocalStorage
        tfpDataDisplayOpen: false,

        // settings
        taxRate: 0.05,

        // state values
        page: 'transactions',
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
        currTx: {},

        // productTypes: TfpData,
        productTypes: tfpData,
        txId: 1,
        newItems: [],
        newTransaction: {},

        currentShow: { dateOfShow: date.formatDate(Date.now(), 'YYYY-MM-DD'), market: 0, teamName: 0, totalSales: 0 },
        currentShowId: 0,

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
      // if (typeof tfpData !== 'undefined') alert('tfpData defined')

      if (this.tfpData == null) {
        alert('tfpData null')
        this.tfpData = this.TpfData
        alert(tfpData)
      }
      else {
        // alert('tfpData not null')
        this.calculateTotal()
      }
      this.txId = Math.max(...Object.keys(tfpData.transactions).map(k => tfpData.transactions[k]['id']))
    },

    events: {
      daySaved (data) {
        alert('in onDaySaved')
        this.$broadcast('onDayChanged', data)
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

      calculateTotal () {
        let _runningTotal = 0.0
        for (let tx of Object.keys(this.tfpData.transactions)) {
          _runningTotal += this.tfpData.transactions[tx].total + this.tfpData.transactions[tx].tax
        }
        this.currentShow.totalSales = _runningTotal
      },

      startNewTransaction () {
        this.newItems = []
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
      },

      saveToLocalStorage () {
        LocalStorage.set('tfpData', this.tfpData)
        LocalStorage.set('transactions', this.tfpData.transactions)
        LocalStorage.set('transactionItems', this.tfpData.transactionItems)
      },

      reloadTFPData () {
        this.tfpData = TfpData
      },

      clearLocalStorageTransactions () {
        this.tfpData.transactions = {}
        this.tfpData.transactionItems = {}
        this.txId = 0
        LocalStorage.set('tfpData', this.tfpData)
        LocalStorage.set('transactions', this.tfpData.transactions)
        LocalStorage.set('transactionItems', this.tfpData.transactionItems)
      },

      displayTFPData () {
        this.tfpDataDisplayOpen = tfpData
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
        // alert(JSON.stringify(this.newItems))
      },

      saveTransaction () {
        let _tfpData = this.tfpData
        this.newTransaction.pp_or_pl = this.pp ? 'pl' : 'pp'
        this.newTransaction.total = this.transactionTotal
        this.newTransaction.tax = this.transactionTax
        _tfpData.transactions[this.newTransaction.id] = this.newTransaction

        let _newTx = this.newTransaction
        let _id = this.txId
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
        // alert(this.currentShow.totalSales)
        // alert(this.transactionTotal)
        // alert(JSON.stringify(this.tfpData.transactions))
        // alert(JSON.stringify(_tfpData.transactions))
        this.currentShow.totalSales += this.transactionTotal
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
        this.saveTransaction()
        this.page = 'transactions'
      },

      openDayStart () {
        this.$refs.dayStart.open()
      },

      daySaved (dayObj) {
        this.currentShow = dayObj
        let days = this.tfpData.dayInfo
        let newId = Math.max(...Object.keys(days)) + 1
        Object.assign(days, {[newId.toString()]: { id: newId, marketId: this.currentShow.market, showDate: this.currentShow.dateOfShow, teamId: this.currentShow.teamName }})
        this.currentShowId = newId
      },

      loadTransactionIntoTable () {
        // this.newTransaction = tfpData.transactions[editTxId]

        // this.$refs.chooseQty.close()
        // this.calculateTransactionTotals()
      }
    }
  }
</script>

<style>
</style>
