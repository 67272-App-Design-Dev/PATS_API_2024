class PetsController < ApplicationController
    # Start with swagger docs info
  swagger_controller :pets, "Pet Management"

  swagger_api :index do
    summary "Fetches all Pet objects"
    notes "This lists all the pets in PATS system"
    param :query, :active, :boolean, :optional, "Filter on whether or not the pet is active"
    param :query, :alphabetical, :boolean, :optional, "Order pets alphabetically by name"

  end

  swagger_api :show do
    summary "Shows one Pet object"
    param :path, :id, :integer, :required, "Pet ID"
    notes "This lists details of one pet in PATS"
    response :not_found
  end

  swagger_api :create do
    summary "Creates a new Pet"
    param :form, :name, :string, :required, "Name"
    param :form, :animal_id, :integer, :required, "Animal ID"
    param :form, :owner_id, :integer, :required, "Owner ID"
    param :form, :female, :boolean, :optional, "Female"
    param :form, :date_of_birth, :date, :optional, "Date of Birth"
    param :form, :active, :boolean, :optional, "Active"
    response :not_acceptable
  end

  swagger_api :update do
    summary "Updates an existing Pet"
    param :path, :id, :integer, :required, "Pet ID"
    param :form, :name, :string, :optional, "Name"
    param :form, :animal_id, :integer, :optional, "Animal ID"
    param :form, :owner_id, :integer, :optional, "Owner ID"
    param :form, :female, :boolean, :optional, "Female"
    param :form, :date_of_birth, :date, :optional, "Date of Birth"
    param :form, :active, :boolean, :optional, "Active"
    response :not_found
    response :not_acceptable
  end

  swagger_api :destroy do
    summary "Deletes an existing Pet"
    param :path, :id, :integer, :required, "Pet ID"
    response :not_found
    response :not_acceptable
  end

  # ----------------------
  # Actual controller code

  before_action :set_pet, only: [:show, :update, :destroy]

  def index
    # Get all the pets (unfiltered)
    @pets = Pet.all
    # Filter by active/inactive if requested
    if(params[:active].present?)
      @pets = params[:active] == "true" ? @pets.active : @pets.inactive
    end
    # Order by name if requested
    if params[:alphabetical].present? && params[:alphabetical] == "true"
      @pets = @pets.alphabetical
    end
    # WAIT... Don't I have a bunch of scopes for filtering pets?
    # Yes, I do!  There's got to be a better way to do this, especially
    # now that I know about refactoring and the Ruby object model.
    # I'll come back to this later in the next branch.  ;-)

    # Output the json for the requested pets
    render json: PetSerializer.new(@pets).serialized_json

  end

  def show
    render json: @pet
    render json: PetSerializer.new(@pet).serialized_json
  end

  def create
    @pet = Pet.new(pet_params)
    if @pet.save
      render json: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  def update
    if @pet.update(pet_params)
      render json: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @pet.destroy
    if !@pet.destroyed
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  private
  def set_pet
    @pet = Pet.find(params[:id])
  end

  def pet_params
    params.permit(:name, :animal_id, :owner_id, :female, :date_of_birth, :active)
  end

end
