<template>
  <div ref="productTypeMaint" v-if="page == 'productTypes'" class="row">

    <q-card flat class="row col-lg-12">
      <q-card-title>Product Types</q-card-title>
    </q-card>
    <div id="productTypes" v-for="item in tfpData.productTypes" v-bind:key="item.name" class="row col-lg-6">
      <q-card class="row col-lg-12">
        <q-card-main class="row col-sm-8">
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
        </q-card-main>
        <q-card-media class="row col-sm-2">
          <img :src= "'./statics/'+item.img" :height="100" :width="100">
        </q-card-media>
        <q-card-actions class="row col-sm-1">
          <q-btn class="col-xs-2 col-sm-12" icon="edit" color="primary" small style="width: 100%; margin-top: 10px;" @click="editTransaction(tx)">Edit</q-btn>
          <q-btn class="col-xs-2 col-sm-12" icon="delete" color="primary" small style="width: 100%; margin-top: 10px;" @click="deleteTransaction(tx)">Delete</q-btn>
        </q-card-actions>
      </q-card>
    </div>
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
    QModal,
    QSelect
  } from 'quasar'

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
      QModal,
      QSelect
    },

    props: ['tfpData', 'page'],

    data () {
      return {
      }
    },

    computed: {
    },

    methods: {
    }
  }
</script>
