<template>
  <div ref="productTypeMaint" v-if="page == 'productTypes'" class="row">
    <q-btn icon-right="add" @click="addNewProductType()" color="primary" class="full-width">Add New Product Type</q-btn>

    <product-type ref="productType" class="full-width" :current="{}" :tfpData="tfpData"></product-type>

    <q-card flat class="row col-lg-12">
      <q-card-title>Product Types</q-card-title>
    </q-card>
    <div id="productTypes" v-for="item in tfpData.productTypes" v-bind:key="item.name" class="row col-lg-6">
      <q-card class="row col-lg-12">
        <q-card-main class="row col-sm-8 col-lg-12">
          <div class="col-sm-12 col-lg-7">
            <div class="row col-sm-12">
              <div class="row col-xs-11 col-sm-2">
                <span class="col-xs-12 col-sm-4 text-bold">Id:</span>
                <span class="col-xs-6 col-sm-6">{{item.id}}</span>
              </div>
              <div class="row col-xs-1 col-sm-1" />
              <div class="row col-xs-12 col-sm-8">
                <span class="col-xs-12 col-sm-3 text-bold">Name:</span>
                <span class="col-xs-12 col-sm-8">{{item.name}}</span>
              </div>
            </div>
            <div class="row col-sm-12">
              <span class="col-xs-12 col-sm-3 text-bold">Description:</span>
              <span class="col-xs-6 col-sm-9">{{item.desc}}</span>
            </div>
            <div class="row col-sm-12">
              <span class="col-xs-12 col-sm-3 text-bold">Image:</span>
              <span class="col-xs-6 col-sm-9">{{item.img}}</span>
            </div>
          </div>
          <div class="col-lg-3">
            <img :src= "'./statics/'+item.img" style="max-width: 100%; max-height: 100% transform: scale(1);">
          </div>
          <div class="col-lg-2">
            <q-btn class="col-xs-2 col-sm-12" icon="edit" color="primary" small style="width: 100%; margin-top: 10px;" @click="editTransaction(tx)">Edit</q-btn>
            <q-btn class="col-xs-2 col-sm-12" icon="delete" color="primary" small style="width: 100%; margin-top: 10px;" @click="deleteTransaction(tx)">Delete</q-btn>
          </div>
        </q-card-main>
      </q-card>
    </div>

    <q-modal class="minimized" ref="productTypeModal" :content-css="{minWidth: '40vw', minHeight: '40vh'}">
      <q-card>
        <q-card-title>
          Product Type
        </q-card-title>
        <q-card-separator />
        <q-card-main ref="product-type">
          <q-field label="Id">
            <q-input v-model="current.id"></q-input>
          </q-field>

          <q-field label="Name">
            <q-input v-model="current.name" placeholder="name of the product type"></q-input>
          </q-field>

          <q-field label="Description">
            <q-input v-model="current.desc" placeholder="description of the product type"></q-input>
          </q-field>

          <q-field label="Image">
            <q-input v-model="current.img" placeholder="image of the product type"></q-input>
          </q-field>

          <q-btn icon-right="save" @click="save()" color="primary">Save</q-btn>
          <q-btn icon-right="cancel" @click="$refs.dayStart.close()" color="primary">Close</q-btn>
        </q-card-main>
      </q-card>
    </q-modal>
  </div>
</template>

<script>
  import {
    date,
    QBtn,
    QCard,
    QCardActions,
    QCardMain,
    QCardMedia,
    QCardSeparator,
    QCardTitle,
    QDatetime,
    QField,
    QInlineDatetime,
    QInput,
    QModal,
    QSelect
  } from 'quasar'

  import ProductType from './ProductType.vue'

  export default {
    components: {
      date,
      QBtn,
      QCard,
      QCardActions,
      QCardMain,
      QCardMedia,
      QCardTitle,
      QCardSeparator,
      QDatetime,
      QField,
      QInlineDatetime,
      QInput,
      QModal,
      QSelect,
      ProductType
    },

    props: ['tfpData', 'page'],

    data () {
      return {
        modalOpen: false,
        current: {}
      }
    },

    mounted: function () {
      alert('in mounted')
      // alert(this.modalOpen)
      if (!this.current) {
        alert(this.current)
        this.current = {
          id: 0,
          name: '',
          desc: '',
          img: '',
          dateCreated: Date.now(),
          dateModified: Date.now()
        }
      }
    },

    computed: {
    },

    methods: {
      addNewProductType () {
        alert('calling productTypeModal')
        this.$refs.productType.open()
      }
    }
  }
</script>
