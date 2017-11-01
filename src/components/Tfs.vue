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
              <q-item-main label="Clear Transaction Data" />
            </q-item>
            <q-item @click="clearLocalStorageDayInfo()">
              <q-item-main label="Clear DayInfo Data" />
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

    <q-btn v-if="page == 'transactions'" icon-right="add" @click="startNewTransaction()" color="primary" class="full-width">Start New Transaction</q-btn>
    <q-btn v-if="page == 'new-transactions'" icon-left="navigate_before" @click="page = 'transactions'" color="primary" class="full-width">Back to Transaction List</q-btn>

    <day-start ref="dayStart" class="full-width" :currentShowId="currentShowId" :currentShow="currentShow" :tfpData="tfpData" v-on:daySaved="daySaved"></day-start>

    <daily-summary ref="dailySummary" :currentShow="currentShow" :tfpData="tfpData" :currentShowID="currentShowId"></daily-summary>

    <transactions ref="transactions" :page="page" :tfpData="tfpData" v-on:editTransaction="editTransaction" v-on:deleteTransaction="deleteTransaction"></transactions>

    <newTransaction ref="newTransaction" :txId="txId" :txEdit="txEdit" :tfpData="tfpData" :showId="currentShowId" v-on:transactionSaved="transactionSaved"></newTransaction>

    <q-modal ref="basicModal">
      <h4>Current Data View</h4>
      <pre>
       {{JSON.stringify(tfpData, null, 2)}}
      </pre>
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
    QIcon,
    QInput,
    QItem,
    QItemSide,
    QItemMain,
    QLayout,
    QList,
    QListHeader,
    QModal,
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
  import NewTransaction from './NewTransaction.vue'

  export default {
    name: 'app',
    components: {
      date,
      dom,
      event,
      openURL,
      LocalStorage,

      QBtn,
      QIcon,
      QInput,
      QItem,
      QItemSide,
      QItemMain,
      QLayout,
      QList,
      QListHeader,
      QModal,
      QToolbar,
      QToolbarTitle,

      DailySummary,
      Transactions,
      DayStart,
      NewTransaction
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
        txId: 0,
        newItems: [],
        newTransaction: {},
        txEdit: false,

        currentShow: { dateOfShow: date.formatDate(Date.now(), 'YYYY-MM-DD'), market: 0, teamName: 0, totalPpSales: 0, totalPlSales: 0, totalSales: 0 },
        currentShowId: 0
      }
    },

    mounted: function () {
      if (this.tfpData == null) {
        alert('tfpData null')
        this.tfpData = this.TpfData
        alert(tfpData)
      }
      else {
        this.calculateTotal()
      }
      this.txId = Math.max(...Object.keys(tfpData.transactions).map(k => tfpData.transactions[k]['id']))
      if (this.txId === Number.POSITIVE_INFINITY || this.txId === Number.NEGATIVE_INFINITY) this.txId = 0
      alert('TFS mounted: ' + this.txId)
      this.currentShowId = Math.max(...Object.keys(tfpData.dayInfo).map(k => tfpData.dayInfo[k]['id']))
      if (this.currentShowId === Number.POSITIVE_INFINITY || this.currentShowId === Number.NEGATIVE_INFINITY) this.currentShowId = 0
    },

    methods: {
      // selectedTransactionItems (tx) {
      //   if (this.tfpData.transactions === '') return null
      //   let _obj = this.tfpData.transactionItems
      //   let _filtered = {}
      //   Object.keys(_obj).forEach(function (key) {
      //     if (_obj[key].transactionId === tx.id) _filtered[key] = _obj[key]
      //   })
      //   // alert(JSON.stringify(_filtered, null, 4))
      //   return _filtered
      // },

      startNewTransaction () {
        this.page = 'new-transactions'
        this.$nextTick(function () {
          this.txId++
          this.$refs.newTransaction.startNewTransaction(this.txId)
        })
      },

      calculateTotal () {
        let _runningPpTotal = 0.0, _runningPlTotal = 0.0, _runningTotal = 0.0
        let _transactions = this.tfpData.transactions
        for (let tx of Object.keys(_transactions)) {
          let itemTotal = _transactions[tx].total + _transactions[tx].tax
          if (_transactions[tx].pp_or_pl === 'pl') _runningPlTotal += itemTotal
          if (_transactions[tx].pp_or_pl === 'pp') _runningPpTotal += itemTotal
          _runningTotal += itemTotal
        }
        this.currentShow.totalPlSales = _runningPlTotal
        this.currentShow.totalPpSales = _runningPpTotal
        this.currentShow.totalSales = _runningTotal
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

      clearLocalStorageDayInfo () {
        this.tfpData.dayInfo = {}
        this.tfpData.dayInfoPersons = {}
        this.tfpData.dayInfoTeams = {}
        this.dayInfoId = 0
        LocalStorage.set('tfpData', this.tfpData)
        LocalStorage.set('dayInfo', this.tfpData.dayInfo)
        LocalStorage.set('dayInfoPersons', this.tfpData.dayInfoPersons)
      },

      displayTFPData () {
        this.tfpDataDisplayOpen = tfpData
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

      editTransaction (data) {
        // this.newTransaction = data[0]
        // this.newItems = [data[1]]
        this.page = 'new-transactions'
        this.txId = data[0]
        this.txEdit = true
        this.$nextTick(function () {
          this.$refs.newTransaction.startNewTransaction()
        })
        this.calculateTotal()
      },

      deleteTransaction (data) {
        this.page = 'transactions'
        const filteredItems = Object.keys(this.tfpData.transactionItems)
          .reduce((obj, key) => {
            if (this.tfpData.transactionItems[key].transactionId !== data[0].id) obj[key] = this.tfpData.transactionItems[key]
            return obj
          }, {})

        this.tfpData.transactionItems = filteredItems
        const filtered = Object.keys(this.tfpData.transactions)
          .reduce((obj, key) => {
            if (this.tfpData.transactions[key].id !== data[0].id) obj[key] = this.tfpData.transactions[key]
            return obj
          }, {})
        this.tfpData.transactions = filtered
        this.calculateTotal()
      },

      transactionSaved (data) {
        // this.newTransaction, this.newItems, 'transactions'
        alert('in transactionSaved')
        alert(JSON.stringify(data[0]))
        this.txId = data[0].id
        this.page = data[2]
        this.calculateTotal()
      }
    }
  }
</script>

<style>
</style>
