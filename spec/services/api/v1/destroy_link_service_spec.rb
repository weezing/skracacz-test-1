describe Api::V1::DestroyLinkService do
  it 'destroys link' do
    link = create(:link)
    service = described_class.new(link)

    expect{ service.call }.to change(Link, :count).by(-1)
  end
end
